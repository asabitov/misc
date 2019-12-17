#!/usr/bin/python3

import boto3
import random
import string
import time

awsRegion = ""
accessKeyId = ""
secretAccessKey = ""

inputStream = "kinesis-stream-task1"
letters = string.ascii_lowercase

client = boto3.client('kinesis', endpoint_url="http://localhost:4568")

while True:
    data = ''.join(random.choice(letters) for x in range(8))
    print(data)

    b_data  = bytes(data+" ", 'utf-8')
    response = client.put_record(StreamName=inputStream, Data=b_data, PartitionKey="partitionKey")
    print(response)

    time.sleep(1)

