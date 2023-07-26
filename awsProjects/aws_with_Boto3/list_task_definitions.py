import boto3
import json
client = boto3.client("ecs", region_name="eu-west-1")
paginator = client.get_paginator('list_task_definition_families')
response_iterator = paginator.paginate(
    PaginationConfig={
        'PageSize':100
    }
)
for each_page in response_iterator:
    print(each_page['families'])