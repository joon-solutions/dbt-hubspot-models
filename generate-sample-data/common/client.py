from typing import Dict, List, Tuple
import json
import requests
from requests.auth import AuthBase
from requests import models
from sqlalchemy import create_engine
from textwrap import dedent
import pandas as pd
from pandas import DataFrame
from io import StringIO
from urllib.parse import quote_plus as urlquote
from copy import deepcopy

DEFAULT_ROW_COUNT = 100
INCREMENT_ROW_COUNT = 50
DEFAULT_STRING_MKR_TYPE = "Slogan"
DEFAULT_DISTINCT_ROW_CHECK = 200
CUSTOM_LIST_THRESHOLD = 10
NAME_MAPPING_PATH = "common/name_mapping.json"
DATATYPE_MAPPING_PATH = "common/datatype_mapping.json"
DATE_DATATYPE = ["date","time"]
DEFAULT_PARAM = {
    "count":DEFAULT_ROW_COUNT
}

def read_json(path: str) -> Dict:
    """
    Read json file from local machine
    """
    with open(path) as file:
        return json.load(file)

NAME_MAPPING = read_json(NAME_MAPPING_PATH)
DATATYPE_MAPPING = read_json(DATATYPE_MAPPING_PATH)

class TableMetadataExtractor:

    COL_LIST = ["table_name","column_name","data_type"]

    def __init__(self
        ,account,user,password
        ,database,schema
        ,table_list
        ,warehouse=None
        ) -> None:
        self.database,self.schema,self.table_list = database,schema,table_list
        self._conn_str = self._build_conn_str(account,user,password,database,warehouse)
        self.engine = create_engine(self._conn_str)

    @property
    def table_list_mtdt(self) -> Dict:
        """
        Return metadata for all tables in table_list
        """
        return self.query_mtdt_to_dict()

    @staticmethod
    def _build_conn_str(account,user,password,database,warehouse) -> str:
        """
        Build Snowflake SQLAlchemy connection string
        """
        warehouse_param = f"?warehouse={warehouse}"
        conn_str = f"snowflake://{user}:{urlquote(password)}@{account}/{database}/{warehouse_param}"
        return conn_str

    def _build_metadata_query(self) -> str:
        """
        Build query to get table metadata
        """
        transformed_table_list = [f"'{i}'" for i in self.table_list]
        table_name_part = f"AND TABLE_NAME IN ({','.join(transformed_table_list)})"
        
        query = dedent(f"""
        SELECT 
            TABLE_CATALOG 
            ,TABLE_SCHEMA 
            ,TABLE_NAME 
            ,COLUMN_NAME
            ,DATA_TYPE 
            ,CHARACTER_MAXIMUM_LENGTH 
        FROM {self.database}.INFORMATION_SCHEMA.COLUMNS
        WHERE
            TABLE_SCHEMA = '{self.schema}'
            {table_name_part}
        """)
        
        return query

    def query_metadata(self) -> DataFrame:
        """
        Make query and return metadata as JSON
        """
        # Only receive either table or table_list
        query = self._build_metadata_query()
        print("Querying metadata")
        df = pd.read_sql(query,self.engine)
        result = df[self.COL_LIST]
        return result

    def query_mtdt_to_dict(self) -> Dict:
        """
        Query metadata and convert to dict object
        Return: Dict with list of column name and column data type
        Example output: {
            "ACCOUNT":[
                {
                    "column_name":"ID"
                    ,"data_type":"TEXT"
                }
            ]
        }
        """
        output_dict = {}
        df_result = self.query_metadata()
        for index,row in df_result.iterrows():
            table_name,col_name,data_type = row
            if table_name not in output_dict:
                output_dict[table_name] = []
            output_dict[table_name].append({
                "column_name":col_name
                ,"data_type":data_type
            })
        return output_dict


class CustomAuth(AuthBase):

    def __init__(self,key: str, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.key = key
    
    def __call__(self, r: models.PreparedRequest) -> models.PreparedRequest:
        """
        Modify request and add authentication before sending
        """
        key_dict = {
            "key":self.key
        }
        r.prepare_url(r.url,key_dict)
        return r

class MockarooAPIClient:

    HOST_URL = "https://api.mockaroo.com/api"
    GENERATE_PATH = "generate.csv"
    DATASET_PATH = "datasets"

    def __init__(self,key: str) -> None:
        self.generate_url = f"{self.HOST_URL}/{self.GENERATE_PATH}"
        self.dataset_url = f"{self.HOST_URL}/{self.DATASET_PATH}"
        self._auth = CustomAuth(key)

    @staticmethod
    def _create_compound_cond(column_name: str, cond_list: List):
        """
        Build compound check condition from input list
        """
        output_cond_list = []
        column_name_lower = column_name.lower()
        for cond in cond_list:
            if isinstance(cond,str):
                output_cond_list.append(cond in column_name_lower)
            elif isinstance(cond,list):
                output_cond_list.append(
                    all(i in column_name_lower for i in cond)
                )
        return any(output_cond_list)
        
    @staticmethod
    def map_db_type(column_type: str) -> Dict:
        """
        Check if column type in DB can be used for Mockaroo type
        Return Mockaroo type dict if mapped
        Return empty dict if not mapped
        """
        for datatype,mkr_type_dict in DATATYPE_MAPPING.items():
            if datatype in column_type.lower():
                return mkr_type_dict
        return None

    def map_column_name(self,column_name: str) -> Dict:
        """
        Check if column name can be parsed for Mockaroo type
        Return Mockaroo type dict if mapped
        Return empty dict if not mapped
        """
        for mkr_type,cond_list in NAME_MAPPING.items():
            cond = self._create_compound_cond(column_name,cond_list)
            if cond:
                return {"type":mkr_type}
        return None

    @staticmethod
    def map_text_col(
            column_name: str
            ,table_name: str
            ,metadata_client: TableMetadataExtractor
            ) -> Dict:
        """
        Map text column to a custom list,or to a default string type in Mockaroo
        Return Mockaroo type dict
        """
        # Check distinct list len
        db = metadata_client.database
        schema = metadata_client.schema
        engine = metadata_client.engine

        check_query = f"""
        SELECT DISTINCT TOP {DEFAULT_DISTINCT_ROW_CHECK} "{column_name}" AS distinct_list
        FROM "{db}"."{schema}"."{table_name}"
        """
        print(f"Selecting distinct values from top 200 rows in table {table_name} for column {column_name}")
        df = pd.read_sql(check_query,engine)

        # Blank or Custom List
        distinct_row_count = len(df.index)
        if distinct_row_count <= CUSTOM_LIST_THRESHOLD:
            custom_list: List = df["distinct_list"].to_list()
            if custom_list[0] is None:
                return {"type":"Blank"}
            else:
                # Make sure list does not have None
                custom_list_no_none = ["" if i is None else i for i in custom_list]
                return {
                    "type":"Custom List"
                    ,"values":custom_list_no_none
                }

        # If cannot use custom list, assign default string type
        return {
            "type":DEFAULT_STRING_MKR_TYPE
        }

    def map_datatype(
            self
            ,column_name: str
            ,columm_type: str
            ,table_name: str
            ,metadata_client: TableMetadataExtractor
            ) -> Dict:
        """
        Map column with a Mockaroo data type
        """
        col_def = self.map_column_name(column_name) # Try to map based on name
        if not col_def: 
            col_def = self.map_db_type(columm_type) # Try to map based on db type    
        if not col_def: # Try to map to text column
            col_def = self.map_text_col(column_name,table_name,metadata_client)
        if not col_def: # Raise error if cannot map
            err_msg = (
                f"Cannot map column {column_name} with type {columm_type} to a Mockaroo type"
                f" in table {table_name}"
            )
            raise ValueError(err_msg)
        return col_def

    def build_generate_body(
            self
            ,table_mtdt_list: List
            ,dataset_col_dict: Dict
            ,table_name: str
            ,metadata_client: TableMetadataExtractor
            ,columns: List
            ) -> Tuple[List]:
        """
        Receive metadata for table and convert to API body payload
        Notable params:
            dataset_col_dict: Dict of columns that reference other columns
                i.e. {}
        Return a tuple of body for API call and list of datetime/timestamp columns
        Example output: (
            [
                {
                    "name":"mycol",
                    "type":"Blank" #Mockaroo type here
                }
            ],
            ["col1","col2"]
        )
        """
        output_list = []
        date_col_list = []
        columns = [c.lower() for c in columns]
        list_len = len(columns) or len(table_mtdt_list)
        counter = 0
        for i in table_mtdt_list:
            column_name,column_type = i.values()
            if columns and column_name.lower() not in columns:
                continue
            counter += 1
            print(f"Processing column {column_name} #{counter} out of {list_len}")

            # Check if column is of datetime type to parse in result later
            if any(cond in column_type.lower() for cond in DATE_DATATYPE):
                date_col_list.append(column_name)

            if dataset_col_dict and column_name in dataset_col_dict:
                col_def = deepcopy(dataset_col_dict[column_name])
            else:
                col_def = deepcopy(self.map_datatype(
                    column_name
                    ,column_type
                    ,table_name
                    ,metadata_client
                    ))
            col_def["name"] = column_name
            output_list.append(col_def)
        return output_list,date_col_list

    def make_generate_call(self,body,row_count: int = None,date_col_list: List = False):
        """
        Call Mockaroo Generate API to create mock data
        date_col_list: List out which columns are datetime type 
            so they can be properly parsed in the Dataframe
        Return pandas Dataframe
        """
        _params = {"count":row_count} if row_count else DEFAULT_PARAM
        resp = requests.post(
            url=self.generate_url
            ,auth=self._auth
            ,params=_params
            ,json=body
        )
        if "error" in resp.text:
            raise ValueError(resp.text)
        df = pd.read_csv(
            StringIO(resp.text),
            parse_dates=date_col_list,
            infer_datetime_format=True,
            )
        return df

    def create_dataset(self,table_name,df: DataFrame):
        """
        Upload dataset to Mockaroo account
        """
        headers = {"Content-Type":"text/csv"}
        url = f"{self.dataset_url}/{table_name}"
        resp = requests.post(
            url=url
            ,auth=self._auth
            ,headers=headers
            ,data=df.to_csv(index=False).encode('utf-8')
        )
        success = resp.json().get("success")
        if success:
            print(f"Dataset for table {table_name} is uploaded to Mockaroo")
        else:
            err_msg = (
                f"Dataset upload for table {table_name} failed."
                f" Response is {resp.text}."
                f" Dataframe is {df.head()}"
                )
            raise ValueError(err_msg)

    def delete_dataset(self,table_name):
        """
        Delete dataset from account
        """
        url = f"{self.dataset_url}/{table_name}"
        resp = requests.delete(
            url=url
            ,auth=self._auth
        )
        success = resp.json().get("success")
        if success:
            print(f"Dataset for table {table_name} is deleted from Mockaroo")
        else:
            err_msg = (
                f"Dataset delete for table {table_name} failed."
                f" Response is {resp.text}"
                )
            raise ValueError(err_msg)