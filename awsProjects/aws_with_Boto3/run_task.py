import boto3
import json
client = boto3.client("ecs", region_name="eu-west-1")
ec2 = boto3.resource('ec2')
response = client.run_task(
    taskDefinition='AWSSampleTD',
    launchType='FARGATE',
    cluster='my-ecs-cluster',
    platformVersion='LATEST',
    count=1,
    #



   #
)
print(json.dumps(response, indent=4, default=str))