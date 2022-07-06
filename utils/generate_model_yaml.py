import os
from argparse import ArgumentParser
from collections import OrderedDict

import snowflake.connector
import yaml
from dotenv import load_dotenv

load_dotenv()

SF_USER = os.getenv("SF_USER")
SF_PASSWORD = os.getenv("SF_PASSWORD")
SF_ROLE = os.getenv("SF_ROLE", "TRANSFORMER")
SF_DATABASE = os.getenv("SF_DATABASE", "raw")
SF_ACCOUNT = os.getenv("SF_ACCOUNT", "uta23508.us-east-1")
SF_WAREHOUSE = os.getenv("SF_WAREHOUSE", "COMPUTE_WH")


def escape(name):
    if name in ("schema", "table", "start", "from", "select", "group"):
        return f'"{name.upper()}"'
    return name


def make_table_key(table_schema, table_name):
    return "-".join((table_schema, table_name)).lower()


def do_query(conn, query, to_df=True, **kwargs):
    with conn.cursor(snowflake.connector.DictCursor) as cursor:
        cursor.execute(query, **kwargs)
        return cursor.fetchall()


def get_pk_cols(conn, table_schema, table_name):
    table_name = escape(table_name)

    sql = f"""
    describe table {SF_DATABASE}.{table_schema}.{table_name}
    """

    rows = do_query(conn, sql, to_df=False)
    pk_cols = [escape(row["name"].lower()) for row in rows if row["primary key"] == "Y"]
    return pk_cols


def get_empty_tables(conn):
    sql = f"""
    select
        table_schema,
        table_name
    from {SF_DATABASE}.information_schema.tables
    where row_count = 0
    """

    rows = do_query(conn, sql)
    return {make_table_key(row["TABLE_SCHEMA"], row["TABLE_NAME"]) for row in rows}


def get_sources(file_path):
    with open(file_path, "r") as file:
        sources = yaml.load(file, Loader=yaml.FullLoader)
    return OrderedDict({src["name"]: src for src in sources["sources"]})


def make_test(pk_cols, model_name, is_empty=True):
    print(f"Found primary key: {pk_cols}, is_empty: {is_empty}")

    p_key = pk_cols[0]
    if len(pk_cols) > 1:
        p_key = " || '-' || ".join(pk_cols)

    tests = ["unique", "not_null"]
    lines = [
        f"  - name: {model_name}",
        f'    description: ""',
    ]

    if not is_empty:
        tests.append("dbt_utils.at_least_one")
    else:
        print("WARNING: table is empty. Please configure table required_tests to None.")
    if model_name.lower() == "group":
        lines.append(f"    identifier: GROUP\n    quoting:\n      identifier: true")

    lines.extend(["    columns:", f"      - name: {p_key}", f"        tests: {tests}"])

    return "\n".join(lines)


def make_schema_yaml(conn, source, empty_tables):
    content = "version: 2\n\nmodels:\n"
    total = len(source["tables"])

    for index, table in enumerate(source["tables"]):
        print(f"\n[{index + 1}/{total}] Table {table['name']}")

        is_empty = False
        if make_table_key(source["name"], table["name"]) in empty_tables:
            is_empty = True

        content += (
            make_test(
                pk_cols=get_pk_cols(conn, source["name"], table["name"]),
                model_name=f"base__{source['name']}_{table['name']}".lower(),
                is_empty=is_empty,
            )
            + "\n\n"
        )

    return content


def run(model_dir, target_src=None, overwrite=False):
    sources = get_sources(os.path.join(model_dir, "sources/schema.yml"))
    print("Loaded Dbt sources")

    with snowflake.connector.connect(
        account=SF_ACCOUNT,
        user=SF_USER,
        password=SF_PASSWORD,
        role=SF_ROLE,
        database=SF_DATABASE,
        warehouse=SF_WAREHOUSE,
    ) as conn:
        print("Connected Snowflake")

        empty_tables = get_empty_tables(conn)
        print("Got emtpy table list")

        for src_name, src in sources.items():
            if target_src and target_src != src_name:
                continue

            print("\n============================\n")
            print(f"Source: {src_name}")

            file_name = os.path.join(model_dir, f"base/{src_name}/schema.yml")
            if not overwrite and os.path.exists(file_name):
                print("Already exists. Skipped.")

            schema_yaml = make_schema_yaml(conn, src, empty_tables)
            with open(file_name, "w") as file:
                file.write(schema_yaml)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--model_dir", type=str, default="./models")
    parser.add_argument("--target_src", type=str, default=None)
    parser.add_argument("-w", "--overwrite", default=False, action="store_true")
    args = parser.parse_args()

    run(**(args.__dict__))
