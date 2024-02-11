import boto3
import json
import csv
from io import StringIO

glue_client = boto3.client('glue')

def read_glue_table(database_name, table_name):
    response = glue_client.get_table(DatabaseName=database_name, Name=table_name)
    storage_descriptor = response['Table']['StorageDescriptor']
    location = storage_descriptor['Location']

    # Assuming the data is in CSV format
    s3_bucket = location.split('/')[2]
    s3_key = '/'.join(location.split('/')[3:])

    s3_client = boto3.client('s3')
    response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
    csv_data = response['Body'].read().decode('utf-8')

    # Convert CSV data to JSON
    json_data = csv_to_json(csv_data)

    return json_data

def csv_to_json(csv_data):
    # Assuming the first row of the CSV contains headers
    csv_reader = csv.DictReader(StringIO(csv_data))
    json_data = json.dumps([row for row in csv_reader], indent=2)

    return json_data

def glue(event, context):
    # Replace 'YourDatabaseName' and 'YourTableName' with your Glue database and table names
    database_name = 'mydb'
    table_name = 'country_csv'

    # Read Glue table and convert data to JSON
    json_data = read_glue_table(database_name, table_name)

    # Print the JSON data
    print(json_data)

    return {
        'statusCode': 200,
        'body': json_data
    }