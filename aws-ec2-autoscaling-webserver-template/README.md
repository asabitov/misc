## AWS EC2 Autoscaling Web Server Template

This Terraform configuration creates a standard AWS EC2 autoscaling web server.

### Get ready

- SSH to your bastion, clone the git repo and go to the working directory:
```
$ mkdir git
$ cd git
$ git clone https://github.com/asabitov/aws-ec2-autoscaling-webserver-template.git
$ cd aws-ec2-autoscaling-webserver-template
```

### Test the node configuration

This step is optional. If testing isn't required then go to the "Bake AMI" step.

- Launch an EC2 instance for testing and add its public IP address under "[aws-ec2-autoscaling-webserver]":
```
$ cd ./ansible
$ sudo vi /etc/ansible/hosts
```
- Run playbook specifying a git repo where you keep your web code:
```
$ ansible-playbook aws-ec2-autoscaling-webserver.yml --private-key=YOUR_SSH_KEY.pem --extra-vars "git_repo=GIT_REPO"
```

### Bake AMI

- Choose a public subnet in the AWS region of your web server and use it to bake the image, specifying a git repo where you keep your website files (do not run the following command as root!):
```
$ cd ./packer
$ /opt/packer/packer build -var 'subnet_id=PUBLIC_SUBNET' -var 'ansible_git_repo=GIT_REPO' aws-ec2-autoscaling-webserver-ami.json
```

### Deploy the solution

- Run to deploy:
```
$ cd ../terraform
$ aws s3 mb s3://aws-ec2-autoscaling-webserver-terraform
$ /opt/terraform/terraform init -backend-config="bucket=aws-ec2-autoscaling-webserver-terraform"
$ /opt/terraform/terraform apply -var-file="terraform.tfvars" -var="ami=BAKED_AMI"
```

### Stress test the web server

