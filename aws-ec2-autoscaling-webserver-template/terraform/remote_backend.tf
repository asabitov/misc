terraform {
    backend "s3" {
        bucket	= ""
        key	= "aws-ec2-autoscaling-webserver.tfstate"
	region	= "ap-southeast-2"
    }
}

