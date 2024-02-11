import boto3
 
def notifi(event, context):
    # Replace 'your-topic-arn' with the actual ARN of your SNS topic
    sns_topic_arn = 'arn:aws:sns:us-west-1:0123456789012:sns_topic'
    # Replace 'your-email@example.com' with the email address to which you want to send the message
    email_address = 'tanmaygarge@gmail.com'
    # Create an SNS client
    sns = boto3.client('sns')
    # Message to be sent
    message = 'Hello, World!'
    # Publish the message to the specified SNS topic
    response = sns.publish(
        Topic_Arn=sns_topic_arn,
        Message=message,
        Subject='Lambda SNS Notification',
        MessageAttributes={
            'email': {
                'DataType': 'String',
                'StringValue': email_address
            }
        }
    )
    print("Message sent:", response)
 
    return {
        'statusCode': 200,
        'body': 'Message sent successfully!'
    }
    