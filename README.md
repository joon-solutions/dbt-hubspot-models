## Canvas dbt project!

Below are guides on how to set up & maintain this project
### Setting up Python environment

- Set up Python environment for developing
    ```bash
    # Create Python virtual environment
    python -m venv path/to/your/venv

    # Install dependencies
    source path/to/your/venv/bin/activate
    pip install -U pip setuptools wheel
    pip install -r requirements.txt
    ```

### Set up pre-commit hook

Pre-commit hooks can be used for checkpoints prior to commiting your codes.
Example: pre-commit is set up for sqlfluff lint

- Install pre-commit hooks

    ```bash
    pre-commit install
    ```

- Uninstall pre-commit hooks

    ```bash
    pre-commit uninstall
    ```

- Refer: [pre-commit](https://pre-commit.com/)
### Dbt common operations

#### 1. Setting up

- Create dbt profiles.yml
  - Refer: [Configure your profile](https://docs.getdbt.com/dbt-cli/configure-your-profile)

- Install dbt dependencies

    ```bash
    dbt deps
    ```

- Check connection

    ```bash
    dbt debug
    ```

#### 2. Generate dbt source, base model YAML files

- Create source YAML file

    ```bash
    dbt run-operation generate_source --args '{"schema_name": "your_schema_name", "database_name": "your_database_name"}'
    ```

- Create base models

    ```bash
    dbt run-operation generate_base_model --args '{"source_name": "your_source_name", "table_name": "your_table_name"}'
    ```

- Create model YAML file

    ```bash
    dbt run-operation generate_model_yaml --args '{"model_name": "model_name_to_create_yaml"}'
    ```

- Refer: [dbt-codegen](https://github.com/dbt-labs/dbt-codegen#generate_model_yaml-source)
#### 3. Run models

- Run normal models

    ```bash
    dbt run -m model_name_or_tag_or_state
    ```

- Run snapshot models

    ```bash
    dbt snapshot -s snapshot_name
    ```

#### 4. Test models

- Run dbt tests

    ```bash
    dbt test -m model_name_or_tag_or_state
    ```

- Check required tests (Refer: [dbt-meta-testing](https://hub.getdbt.com/tnightengale/dbt_meta_testing/latest/))

    ```bash
    dbt run-operation required_tests
    ```

### Linting

- Lint code with

    ```bash
    sqlfluff lint path/to/file/or/folder
    ```

- Auto fix code

    ```bash
    sqlfluff fix path/to/file/or/folder
    ```

- Refer: [sqlfluff](https://github.com/sqlfluff/sqlfluff)

### CI / CD & push_to_master workflow

- A Github Action workflow named **pr_to_master** is available. This workflow is triggered
when a merge request to the main branch is created. It does:
  - Lint code with sqlfluff
  - Check required tests
  - Run models
  - Test models
  - To use this workflow, un-comment all lines in the YAML file `pr_to_master.yml`

- Merging to production is set up on dbtcloud

### Data observability of this project

A data project must have observability on data ETL pipeline as well as BI platform.
- For ETL pipeline:
  - source: re_data package is included in dbt package to monitor sources.
  - base > intermedate > mart: 
    * dbt tests should be employed on all models
    * at minimum: `not_null` and `unique` must be defined for primary keys
- For BI platform:
  - data tests on Looker to ensure final table joins are giving similar result with raw data sources.
  - [Reference](https://community.looker.com/lookml-5/lookml-data-tests-recommendations-and-best-practices-20815)

#### re_data package

`re_data` package is included in this project. Purposes:

- detect and alert on schema changes (potential with new data sources, or during migrations)
- inspect new data sources, for exploration purposes (requires config on relevant `.yml` file or on respective dbt model)
- anomalies detection (required custom macros)
- To generate re_data tables (`full-refresh` is optional, as some tables are incrementally-built, this is reserved for case where you want to clear the whole table and rebuild - on dev branch only)

    ```bash
    dbt run --models package:re_data [--full-refresh]
    ```

- To generate & serve doc (similar with dbt, will generate a page for data visibility):

    ```bash
    re_data overview generate && re_data overview serve
    ```
### Disabling models

When setting up your connection in Fivetran, it is possible that not every table this package expects will be synced. This can occur because you either don't use that functionality or have actively decided to not sync some tables. In order to disable the relevant functionality in the package, you will need to add the relevant variables. By default, all variables are assumed to be `true`. You only need to change the value for variables for the tables you would like to disable or enable respectively in fct_project.yml.
For example:

....
config-version: 2
...
vars:
    contact_form_submission_enabled: false

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
- Checkout [re_data](https://docs.getre.io/latest/docs/introduction/whatis) for its features and documentations
