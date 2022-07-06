import os
import subprocess
from argparse import ArgumentParser
from collections import OrderedDict

import yaml

DEFAULT_PROFILE_DIR = "~/.dbt"
DEFAULT_TYPE = "base"


def generate_base_model(table_name, source_name, profiles_dir=DEFAULT_PROFILE_DIR):
    print(f"Generating base model for table {table_name}")
    bash_command = (
        f"dbt run-operation"
        " generate_base_model"
        f" --profiles-dir {profiles_dir}"
        f' --args \'{{"source_name": "{source_name}", "table_name": "{table_name}"}}\''
    )
    output = subprocess.check_output(bash_command, shell=True).decode("utf-8")
    sql_index = output.find("with source as")
    sql_query = output[sql_index:]
    return sql_query


def get_sources(file_path):
    with open(file_path, "r") as file:
        sources = yaml.load(file, Loader=yaml.FullLoader)
    return OrderedDict({src["name"]: src for src in sources["sources"]})


def mk_base_dir(model_dir, source_name):
    model_dir = os.path.join(model_dir, "base", source_name)
    os.makedirs(model_dir, exist_ok=True)
    return model_dir


def generate(source, base_dir, overwrite=False, target_table=None, **kwargs):
    total = len(source["tables"])
    for index, table in enumerate(source["tables"]):
        table_name = table["name"]
        if target_table and target_table != table_name:
            continue

        source_name = source["name"]
        file_name = os.path.join(base_dir, f"base__{source_name}_{table_name}.sql")

        print(f"\n[{index + 1}/{total}] {source_name}.{table_name}")

        if os.path.exists(file_name) and not overwrite:
            print(f"Base model exists already at {file_name}. Skipped.")
            continue

        query = generate_base_model(table_name, source_name, **kwargs)
        with open(file_name, "w") as file:
            file.write(query)
        print(f"Generated at {file_name}")


def run(model_dir, target_src=None, **kwargs):
    sources = get_sources(os.path.join(model_dir, "sources/schema.yml"))

    for src_name, src in sources.items():
        if target_src and target_src != src_name:
            continue

        print(f"Source: {src_name}")
        base_dir = mk_base_dir(model_dir, src["name"])
        generate(src, base_dir, **kwargs)

        print("\n============================\n")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--model_dir", type=str, default="./models")
    parser.add_argument("--profiles_dir", type=str, default="~/.dbt")
    parser.add_argument("--target_src", type=str, default=None)
    parser.add_argument("--target_table", type=str, default=None)
    parser.add_argument("-w", "--overwrite", default=False, action="store_true")
    args = parser.parse_args()

    run(**(args.__dict__))
