import os
from common.helpers import (
    read_json,
    MockDataGenerator,
    )

# Init db engine

SECRET_FOLDER = "secrets"
CRED_PATH = "config.json"
cred_file_path = os.path.join(SECRET_FOLDER,CRED_PATH)

secrets = read_json(cred_file_path)

# Read input
INPUT_FOLDER = "input"
INPUT_PATH = "input_data.json"
input_file_path = os.path.join(INPUT_FOLDER,INPUT_PATH)
inputs = read_json(input_file_path)

# Output
OUTPUT_PATH = "output"

mock_generator = MockDataGenerator(secrets=secrets,input=inputs)
output = mock_generator.generate_data()

d=1