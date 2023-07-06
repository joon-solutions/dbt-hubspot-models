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

When setting up your connection in Fivetran, it is possible that not every table this package expects will be synced. This can occur because you either don't use that functionality or have actively decided to not sync some tables. In order to disable the relevant functionality in the package, you will need to add the relevant variables. By default, all variables are assumed to be `true`. You only need to change the value for variables for the tables you would like to disable or enable respectively in dbt_project.yml.
For example:

....
config-version: 2
...
vars:
    contact_form_submission_enabled: false

### UTM Auto Tagging Feature
This package assumes you are manually adding UTM tags to the `final_url` field within the `ad_history` table. If you are leveraging the auto-tag feature within Microsoft Ads then you will want to enable the `microsoft_auto_tagging_enabled` variable to correctly populate the UTM fields within the `int_microsoft_ads__ad_history` model in dbt_project.yml.

For example:

....
config-version: 2
...
vars:
  microsoft_auto_tagging_enabled: true # False by default

### Switching to Local Currency
Additionally, the model allows you to select whether you want to add in costs in USD or the local currency of the ad. By default, the package uses USD. If you would like to have costs in the local currency, add the following variable to your `dbt_project.yml` file:

For example:

....
config-version: 2
...
vars:
    linkedin__use_local_currency: True

### Passing Through Additional Metrics
By default, the model will select `clicks`, `impressions`, and `costs` from the source `ad_analytics_by_creative` table to store into the `*_ad_adapter` model. If you would like to pass through additional metrics to the ad adapter model, add the following configuration to your `dbt_project.yml` file:

For example:

....
config-version: 2
...
vars:
    linkedin__passthrough_metrics: ['the', 'list', 'of', 'metric', 'columns', 'to', 'include']

### Naming Convention
- dbt layer:
    - non_aggregated fields: use descriptive name
    - aggregated fields:
        - suffix _count: when use "count" function
        - prefix unique_ and suffix _count: when use "count distinct" function
        - prefix avg_: when use "average" function
        - prefix total_: when use "sum" function
        - [numerator]_per_[denominator]: when calculate the ratios between two other fields
        - prefix is_ or has_: used for boolean fields
- metrics layer:
    - Lightdash dimension: same as field name
    - Lightdash metrics:
        - derived from non_aggregated fields: same convention as used for aggregated fields
        - derived from aggregated fields: add suffix _agg
        For ex:
        - name: count_clicks
            meta:
            dimensions:
                type: number
            metrics:
                count_schedule_agg:
                    type: sum


### Shopify source: 
#### Union multiple connectors
If you have multiple Shopify connectors in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `shopify_union_schemas` OR `shopify_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
    shopify_union_schemas: ['shopify_usa','shopify_canada'] # use this if the data is in different schemas/datasets of the same database/project
    shopify_union_databases: ['shopify_usa','shopify_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
#### Setting your timezone
By default, the data in your Shopify schema is in UTC. However, you may want reporting to reflect a specific timezone for more realistic analysis or data validation. 

To convert the timezone of **all** timestamps in the package, update the `shopify_timezone` variable to your target zone in [IANA tz Database format](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones):
```yml
# dbt_project.yml

vars:
    shopify_timezone: "America/New_York" # Replace with your timezone
```
### Instructions for user-input file:
`rpt__shopify__inventory_alert` uses 2 user-input fields: `safety stock` and `lead time` from `inventory_user_input.csv` file. 
In this file, please read the following descriptions & fill in the fields accordingly
- Source relation: The schema or database union together from multiple Shopify connectors
- Sku: The item's SKU (stock keeping unit)
- Safety stock: The amount of extra stock by sku, if any, that sellers keep in their inventory to help avoid stockouts
- Lead time: Days needed (in days) for vendors to fulfill each sku's items on a reorder

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
- Checkout [re_data](https://docs.getre.io/latest/docs/introduction/whatis) for its features and documentations
