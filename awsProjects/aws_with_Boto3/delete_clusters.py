import boto3
import json
client = boto3.client("ecs", region_name="eu-west-1")
response = client.delete_cluster(cluster="my-ecs-cluster")
print(json.dumps(response, indent=4))