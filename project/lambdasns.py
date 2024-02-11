import boto3
import os
 
def notification(event, context):
    topic_arn = os.environ["topic_arn"]
 

    subscription_arn = 'arn:aws:sns:sns_topic:email-target-id'
    message = 'Hello, You have completed your project succesfully!'
    
    sns_client = boto3.client('sns')
    
    response = sns_client.publish(
        TopicArn=topic_arn,
        Message=message,
        Subject='Test Subject'
    )
    
    print(f"MessageId: {response['MessageId']}")