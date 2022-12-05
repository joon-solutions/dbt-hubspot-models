from typing import Dict, List, Tuple
import json
import os
from copy import deepcopy
from common.client import (
    TableMetadataExtractor,
    MockarooAPIClient,
    DEFAULT_ROW_COUNT,
    INCREMENT_ROW_COUNT,
    read_json
)

OUTPUT_FOLDER = "output"

class MockDataGenerator:
    """
    Class to generate mock data. Perform the following tasks:
    1. Arrange the order in which to generate tables,
        based on the relationship
    2. Make sure table row numbers are adjusted 
        so many-to-one and one-to-one relationship is respected
    3. Call on respective clients to generate mock data and write to destination
    """

    def __init__(self,secrets: Dict, input: Dict) -> None:
        (
            self._account
            ,self._user
            ,self._password
            ,self._warehouse
            ,self._database
            ,self._api_key
            ,self._schema
            ,self.table_list
            ,self.relationship
            ,self.column_dict
            ,self._target_account
            ,self._target_user
            ,self._target_password
            ,self._target_warehouse
            ,self._target_database
        ) = self._parse_config(secrets, input)
        self.api_client = MockarooAPIClient(key=self._api_key)
        self.table_mtdt_client = TableMetadataExtractor(
            account=self._account
            ,user=self._user
            ,password=self._password
            ,database=self._database
            ,schema=self._schema
            ,table_list=self.table_list
            ,warehouse=self._warehouse
        )
        self.destination_client = TableMetadataExtractor(
            account=self._target_account
            ,user=self._target_user
            ,password=self._target_password
            ,database=self._target_database
            ,schema=self._schema
            ,table_list=self.table_list
            ,warehouse=self._target_warehouse
        )
        self.rela_mtdt_dict = self._complete_relationship_dict()
        self.exec_order_list = self._complete_exec_order_list()
        self.clean_up_list = []
        self._inform_execution_plan()


    @staticmethod
    def _parse_config(secrets: Dict, input: Dict) -> None:
        return (
            secrets["account"]
            ,secrets["user"]
            ,secrets["password"]
            ,secrets["warehouse"]
            ,secrets["database"]
            ,secrets["mockaroo_key"]
            ,input["source_schema"]
            ,input["source_tables"].split(",")
            ,input.get("relationship")
            ,input.get("columns",{})
            ,secrets.get("target_account",secrets["account"])
            ,secrets.get("target_user",secrets["user"])
            ,secrets.get("target_password",secrets["password"])
            ,secrets.get("target_warehouse",secrets["warehouse"])
            ,secrets["target_database"]
        )

    @staticmethod
    def _parse_relationship(relationship_dict: Dict):
        """
        Divide dict into one-to-many and one-to-one dicts
        """
        if relationship_dict:
            return (
                relationship_dict.get("one-to-many")
                ,relationship_dict.get("one-to-one")
            )
        else:
            return (None,None)

    @staticmethod
    def _create_relationship_dict(raw_rela_dict: Dict) -> Dict:
        """
        Create relationship dict with metadata
        Params: raw_rela_dict: The raw relationship dict of one-many and one-one relationship
            from input.Example: {
                "one-to-many":[
                    {
                        "one":{"ACCOUNT":"ID"}
                        ,"many":{"OPPORTUNITY":"ACCOUNT_ID"}
                    },
                    {
                        "one":{"USER_ROLE":"ID"}
                        ,"many":{"USER":"USER_ROLE_ID"}
                    },
                    {
                        "one":{"USER":"ID"}
                        ,"many":{"OPPORTUNITY":"OWNER_ID"}
                    }
                ],
                "one-one":[
                    {
                        "one_1":{"EMAIL_EVENT":"ID"}
                        ,"one_2":{"EMAIL_EVENT_BOUNCE":"ID"}
                    }
                ]
            }
        Return: A relationship dict, using which to know 
            which table needs upload (one-side table), 
            which table needs to reference another table (many-side table)
        Example output: {
            "ACCOUNT":{
                "table_name":"ACCOUNT"
                ,"need_upload":True
                ,"relationship":{"one":{"ACCOUNT":"ID"},"many":{"OPPORTUNITY":"ACCOUNT_ID"}}
                ,"row_count":50
                }
            ,"OPPORTUNITY":{
                "table_name":"OPPORTUNITY"
                ,"relationship":{"one":{"ACCOUNT":"ID"},"many":{"OPPORTUNITY":"ACCOUNT_ID"}}
                ,"foreign_params":{
                    "ACCOUNT_ID":{
                        "name":"ACCOUNT_ID"
                        ,"type":"Dataset Column"
                        ,"column":"ID"
                        ,"dataset":"ACCOUNT"
                    }
                }
                ,"need_upload":False
                ,"row_count":50
            }
        }
        """
        DEFAULT_DICT = {"need_upload":False,"row_count":DEFAULT_ROW_COUNT}
        output_dict = {}
        
        # Combine one-many and one-one
        input_list = [i for v in raw_rela_dict.values() for i in v]
        for relationship in input_list:
            # Check if one-many or one-one
            if "many" in relationship:
                one_key = "one"
                many_key = "many"
            else:
                one_key = "one_1"
                many_key = "one_2"

            # Set need_upload=True for table on "one side", to mark upload to Mockaroo
            (one_table,one_col), = relationship[one_key].items()
            one_dict = {
                "table_name":one_table
                ,"need_upload":True
                ,"relationship":relationship
            }
            if one_table not in output_dict:
                output_dict[one_table] = deepcopy(DEFAULT_DICT)
            output_dict[one_table].update(one_dict)

            # Set foreign_params for table on "many/one_2 side",
            # to mark column get data from uploaded dataset
            (many_table,many_col), = relationship[many_key].items()
            many_dict = {
                "table_name":many_table
                ,"relationship":relationship
            }
            foreign_params = {
                many_col:{
                    "name":many_col
                    ,"type":"Dataset Column"
                    ,"column":one_col
                    ,"dataset":one_table
                }
            }
            if many_table not in output_dict:
                output_dict[many_table] = deepcopy(DEFAULT_DICT)
            output_dict[many_table].update(many_dict)
            if "foreign_params" not in output_dict[many_table]:
                output_dict[many_table]["foreign_params"] = {}
            output_dict[many_table]["foreign_params"].update(foreign_params)

        return output_dict

    def _parse_one_to_many(self,raw_rela_dict: Dict) -> List:
        """
        Arrange execution order in which tables are created.
        Update row_count in self.rela_mtdt_dict to reflect relationship when creating dataset
        One table = table that must be generated first. Many table = table generated after
        Logic: 
            - Many-side table must be created after its one-side table
            - When move a table, make sure all its predecessors are moved before it too
        Params: raw_rela_dict: The raw relationship dict of one-many and one-one relationship
            from input. See example in method self._create_relationship_dict
        Return list of tables in the order of execution
        Example output: ["table1","table2"]
        """
        exec_order_list = []
        one_many_dict = {}
        DEFAULT_ONE_MANY_VALUE = {
            "many":[]
            ,"one_2":[]
        }
        # Combine one-many and one-one
        input_list = [i for v in raw_rela_dict.values() for i in v]
        for relationship in input_list:
            # Check if one-many or one-one
            if "many" in relationship:
                one_key = "one"
                many_key = "many"
            else:
                one_key = "one_1"
                many_key = "one_2"
            (one_table,one_col), = relationship[one_key].items()
            (many_table,many_col), = relationship[many_key].items()

            one_list = [one_table]

            # Set up row_count to set for many_tables
            row_count = self.rela_mtdt_dict[one_table]["row_count"]

            # One_many dict: Show which tables (many side) depend on which table (one side)
            # Example: {
            #   "ACCOUNT":{
            #       "many":["OPPORTUNITY","TABLE1"]
            #       ,"one_2":["EVENT","TABLE2"]
            # }
            if one_table not in one_many_dict:
                one_many_dict[one_table] = deepcopy(DEFAULT_ONE_MANY_VALUE)
            one_many_dict[one_table][many_key].append(many_table)

            # Insert one_table into exec_order_list if not already there
            if one_table in exec_order_list:
                pass
            else:
                exec_order_list.append(one_table)

            # Make sure many_tables are after one_table, and their many_tables are after them
            # Perform 2 actions:
            # 1. Move many_table after one_table
            # 2. Update row_count of many_table according to that of one_table

            while True:
                
                # row_count for "many" tables must be more than that of one table
                # row_count for one_2 table is the same as one table
                # Increment row_count for each loop, used for "many" table
                # one_2_row_count is used for one_2 table
                one_2_row_count = row_count
                row_count += INCREMENT_ROW_COUNT
                all_many_tables = []
                for loop_one_table in one_list:
                    loop_one_index = exec_order_list.index(loop_one_table)
                    many_table_dict: Dict = deepcopy(one_many_dict.get(loop_one_table))

                    # Skip if this one_table has no many_tables
                    if many_table_dict is None:
                        continue
                    
                    # Get all "many" and one_2 tables.
                    # many_tables here will be the next one table to scan
                    # in order to make sure their many tables are moved after them
                    all_many_tables = [i for v in many_table_dict.values() for i in v]
                    many_tables = many_table_dict["many"]
                    one_2_tables = many_table_dict["one_2"]

                    # Make sure many_table position is after loop_one_table,
                    # if not, move many_table and its many_tables (recursively) to after loop_one_table
                    for many_table in all_many_tables:

                        # If many_table is already in list, move that table
                        # to after the one_table. Else just insert after one_table
                        if many_table in exec_order_list:
                            many_index = exec_order_list.index(many_table)
                            if many_index < loop_one_index:
                                to_insert = exec_order_list.pop(many_index)
                                exec_order_list.insert(loop_one_index + 1,to_insert)
                        else:
                            exec_order_list.insert(loop_one_index + 1,many_table)

                    # Update row_count for "many" table and one_2 table
                    for many in many_tables:
                        self.rela_mtdt_dict[many]["row_count"] = row_count
                    for one_2 in one_2_tables:
                        self.rela_mtdt_dict[one_2]["row_count"] = one_2_row_count
                
                # Stop the loop if there are no more table to check
                if len(all_many_tables) == 0:
                    break

                # Build new one_list for next iteration
                one_list = deepcopy(all_many_tables)

        return exec_order_list

    def _complete_relationship_dict(self):
        """
        Build relationship dict based on table with or without relationship
        Return: a relationship dict. See method self._create_relationship_dict for example
        """
        DEFAULT_DICT = {"need_upload":False,"row_count":DEFAULT_ROW_COUNT}
        rela_dict = self._create_relationship_dict(self.relationship)
        for table in self.table_list:
            if table not in rela_dict:
                rela_dict[table] = {
                    "table_name":table
                    ,"relationship":None
                    }
                rela_dict[table].update(DEFAULT_DICT)
        return rela_dict

    def _complete_exec_order_list(self):
        """
        Build a list containing execution order of tables with or without relationship
        Return: list of tables in the order of execution. See
            method self._parse_one_to_many for example
        """
        exec_order_list = self._parse_one_to_many(self.relationship)
        for table in self.table_list:
            if table not in exec_order_list:
                exec_order_list.append(table)
        return exec_order_list

    def generate_data(self):
        """
        Generate mock data for all tables in a certain order
        to make sure relationship is retained
        """
        table_list_mtdt = self.table_mtdt_client.table_list_mtdt
        list_len = len(self.exec_order_list)
        for index,table_name in enumerate(self.exec_order_list,start=1):
            rela_mtdt = self.rela_mtdt_dict.get(table_name)
            table_mtdt: List = table_list_mtdt[table_name]
            row_count = rela_mtdt["row_count"]
            dataset_col_dict = None
            # Build request body differently if "many" side
            if "foreign_params" in rela_mtdt: 
                dataset_col_dict = rela_mtdt["foreign_params"]

            requested_cols: List = [i.lower() for i in self.column_dict.get(table_name,[])]
            request_body,date_col_list = self.api_client.build_generate_body(
                table_mtdt_list=table_mtdt
                ,dataset_col_dict=dataset_col_dict
                ,table_name=table_name
                ,metadata_client=self.table_mtdt_client
                ,columns=requested_cols
            )
            print(f"Making generate request for table {table_name} #{index} out of {list_len}")
            output_df = self.api_client.make_generate_call(
                body=request_body,
                row_count=row_count,
                date_col_list=date_col_list
                )

            print(f"Writing data to destination")
            output_path = os.path.join(OUTPUT_FOLDER,f"{table_name}.csv")
            # output_df.to_csv(output_path,index=False)
            output_df.to_sql(
                table_name.lower()
                ,con=self.destination_client.engine
                ,schema=self.destination_client.schema
                ,if_exists="replace"
                ,index=False
                )

            # If is "one" side, create Mockaroo dataset after getting mock data
            # so "many" side can use as a reference
            if rela_mtdt["need_upload"]: 
                print(f"Uploading dataset {table_name} to Mockaroo")
                self.api_client.create_dataset(table_name=table_name,df=output_df)
                self.clean_up_list.append(table_name) # Remember to clean up this table

        self.clean_up()

    def clean_up(self):
        """
        Delete generated datasets on Mockaroo account
        """
        if self.clean_up_list:
            print(f"Deleting {len(self.clean_up_list)} tables from Mockaroo account")
            for table_name in self.clean_up_list:
                self.api_client.delete_dataset(table_name=table_name)
        else:
            print(f"Empty clean up list")


    def _inform_execution_plan(self):
        """
        Print out the execution order and row_num for each table
        """
        inform_list = []
        for table in self.exec_order_list:
            row_num = self.rela_mtdt_dict[table]["row_count"]
            inform_list.append(f"{table}({row_num} rows)")
        msg = (
            f"Execution plan is: "
            f"{' --> '.join(inform_list)}"
            )
        print(msg)