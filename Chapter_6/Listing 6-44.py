import boto3

s3_client = boto3.client('s3')
s3_client.list_objects(Bucket="BucketName")