# Btc

## Task 1

### How to deploy the solution to AWS
- Deploy the solution with Terraform:
```
$ /opt/terraform/terraform init
$ /opt/terraform/terraform apply -var-file="terraform.tfvars"
```
- Push data:
```
$ chmod 750 ./push_data.py
$ ./push_data.py
```

### How to deploy the solution to localstack
- You need to start localstack with using the docker-compose method. Before you do that, please change the following line in "docker-compose.yml":
```
- SERVICES=iam,s3,kinesis,firehose,dynamodb 
```
- Start localstack:
```
$ docker-compose up
```
- Deploy the solution with Terraform:
```
$ /opt/terraform/terraform init
$ /opt/terraform/terraform apply
```
- Push data:
```
$ chmod 750 ./push_data.py
$ ./push_data.py
```

## Task 2
- To complete the task, run:
```
$ ./task2.py [ASG NAME]
```
