import boto3
import json
client = boto3.client("ecs", region_name="eu-west-1")
response = client.create_cluster(clusterName="my-ecs-cluster")
print(json.dumps(response, indent=4))