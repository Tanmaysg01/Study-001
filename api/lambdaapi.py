import json

def lambda_handler(event, context):
    # Sample Lambda function
    # This function responds with a JSON payload
    response = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
        },
        'body': json.dumps({'message': 'Hello from Lambda!'}),
    }

    return response
