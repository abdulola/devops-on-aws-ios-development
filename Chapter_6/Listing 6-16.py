import boto3

client = boto3.client('codecommit')

response = client.create_repository(
    repositoryName='devops-ios-repository',
    repositoryDescription='Example Description'
)

print(response)