# generate-sample-data
Generate sample data from already existing SQL tables. Applied to Snowflake only at the moment

1. Install dependencies: Create a new environment (i.e. with `venv`), activate it and run `pip install -r requirements.txt`
2. Create a file in `secrets` folder named `config.json`. 
3. Input database credentials into `config.json` file based on `config_sample.json`
4. Input table configs into `input/input_data.json` based on other sample input_data_* files. 
- Column name can be either lower or upper case. However use consistent case between `source_tables` and `relationship`
- Use `input_sample.json` as a guide
- For one-one relationship, `one_1` means the table being generated first. `one_2` means the table generated after, its column will reference one in `one_1` table.
5. Run file `gen_data.py`