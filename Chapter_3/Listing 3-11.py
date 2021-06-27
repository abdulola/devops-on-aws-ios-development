#hello_cdk/hello_cdk_stack.py

from aws_cdk import core as cdk
from aws_cdk import aws_s3 as s3

class HelloCdkStack(cdk.Stack):

    def __init__(self, scope: cdk.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        bucket = s3.Bucket(self, "MyFirstBucket", 
            versioned=True,)