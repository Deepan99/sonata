import json
import boto3
import os

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    """
    Lambda function to process uploaded documents.
    """
    print(f"Received event: {json.dumps(event)}")
    
    # Handle API Gateway request
    if 'body' in event:
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Document processing initiated.'})
        }
    
    # Handle S3 EventBridge trigger (example structure)
    if 'detail' in event and 'bucket' in event['detail']:
        bucket_name = event['detail']['bucket']['name']
        object_key = event['detail']['object']['key']
        print(f"Processing document {object_key} from bucket {bucket_name}")
        # Insert document processing logic here (e.g., text extraction, resizing)
        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'Processed {object_key}'})
        }

    return {
        'statusCode': 400,
        'body': json.dumps({'message': 'Unknown event format'})
    }
