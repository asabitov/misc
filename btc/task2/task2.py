#!/bin/python3

import sys
import time
import boto3

asg_name = sys.argv[1]
asg_inst_n_stat_d = {}

client = boto3.client('autoscaling')
ec2 = boto3.resource('ec2')

def get_asg_instance_n_status_dict(asg_n):
    asg_inst = {}

    response = client.describe_auto_scaling_groups(
        AutoScalingGroupNames = [ asg_n ]
    )

    for i in response['AutoScalingGroups'][0]['Instances']:
        asg_inst[i['InstanceId']] = i['HealthStatus']

    return asg_inst

def how_many_healthy_instances_in_asg(asg_n):
    asg_i = get_asg_instance_n_status_dict(asg_n)

    x=0
    for k, v in asg_i.items():
        if v == 'Healthy':
            x += 1

    return x


asg_inst_n_stat_d = get_asg_instance_n_status_dict(asg_name)

for instance in asg_inst_n_stat_d.keys():
    ec2.instances.filter(InstanceIds=[instance]).terminate()
    print("\nTerminated: ", instance)

    # Wait until 9 healthy instances left to confirm that the asg detected
    # that 1 instance is terminated
    print("Waiting for the ASG to detect the change.")
    while how_many_healthy_instances_in_asg(asg_name) != 9:
        time.sleep(1)
        sys.stdout.write('.')
        sys.stdout.flush()
    print("\n")


    # Wait until 10 healthy instances to confirm that the asg replaced
    # the terminated instance
    print("Waiting for the new instance to come up healthy.")
    while how_many_healthy_instances_in_asg(asg_name) != 10:
        time.sleep(1)
        sys.stdout.write('.')
        sys.stdout.flush()
    print("\n")

