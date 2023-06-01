## In this demo we are creating the infrastructure in AWS cloud using Terraform.

Here we are creating a Infrastructure to host simple "Hello World" application. We are using packer to install/configure the necesary packages which include Ngnx as web server, Cloudwatch agent to push logs to cloudwatch, SSM agent for ssh purpose and simple "hello world" index file


Prerequisites

1. Need to have Terraform installed in the host where you are trying to create infra.

    Steps to install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. Need to have packer installed in the host 

    Steps to install [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)

3. Need to install and configure awc cli and aws profile to authenitcate AWS cloud. The profile should have all the necessary access to create resources in AWS cloud

    Steps to install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

    Steps to configure [aws-profile](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/keys-profiles-credentials.html)

## Packer

We are using packer to build the golden ami and consume the same ami for the application to host 'hello world'

The packer configuration files are in __iac/golden_image__ directory

No need to run any packer command to build the ami. It is integrated with terraforn in __iac/provisioners.tf__ file using terraform null_resource

```resource "null_resource" "build_ami" {
  provisioner "local-exec" {
    command = "packer init ."
    working_dir = "./golden_image/"
  }
  provisioner "local-exec" {
    command = "packer build -var 'subnet_id=${module.subnet.*.vpc_public_subnets[0][0]}' -var 'region=${var.region}' -var 'aws_profile=${var.aws_profile}' . "
    working_dir = "./golden_image/"
  }
  triggers = {
    subnet_id = module.subnet.*.vpc_public_subnets[0][0]
    vpc_id    = module.create_vpc[0].vpc-Id
    file_hashes = jsonencode({
      for fn in fileset("./golden_image/script", "**") :
      fn => filesha256("./golden_image/script/${fn}")
    })
  }
  depends_on = [module.subnet]
}
```

## Terraform

All the terraform related files are in __iac__ directory which includes __main.tf__ and __demo.tfvars__ file in root folder.

## Authentication with AWS Cloud

Any IaC tool need to have authentication with the AWS cloud to build, provision and deploy the application service. Here we are about to discuss the two authentication approaches to build and deploy the application.

### Approach 1 - Run Terraform command in an EC2 instance 


Create an IAM role and attach necessary policies to create infra.


Launch an ec2 instance in AWS and install all the package dependencies (terraform, awscli, packer) and make sure this EC2 instance is attached with the above IAM role which we created.

We need to integrate this EC2 machine with our CI/CD tool hence we can deploy the infra


## Approch 2 - By using local aws profile authentication

Create an IAM bot user with programmatic access. Create a IAM profile in the local and configure the same profile in terraform script.

In this demo we align with approach 2

### Directory Structure

We have created all the configuration files in __iac__ folder

```└── iac
    ├── files
    │   └── bash
    ├── golden_image
    │   └── script
    └── modules
        ├── alb
        ├── asg
        ├── ec2
        ├── iam_policy
        ├── iam_role
        ├── launch_template
        ├── log_group
        ├── policy_attachment
        ├── routetable
        ├── scaling_alarm
        ├── scaling_policy
        ├── security_groups
        ├── ssh_key
        ├── subnet
        └── vpc
```


## Handelling terraform statefile.

In this demo we are not locking the terraform statefile. If you want to have the locking mechanism. Create a S3 buckek and dynamo DB table and uncomment the below lines in the __/iac/main.tf__ file.


``` clone the repo
    cd iac
    vim main.tf
```

Replace with respective values and save the file 

```# terraform {
#   backend "s3" {
#     bucket         = "< Replace with Bucket name >"
#     key            = "terraform.tfstate"
#     region         = "< Replace with region >"
#     dynamodb_table = "< Replace with dynamoDB table >"
#     profile = "< Replace with your profile >"
#   }
# }
```


## Steps to recreate this in your infra

## Step 1

Clone the repo (master branch) and change the working directory to iac

```
cd iac

```

## Step 2

Do the necessary changes in demo.tfvars

please be cautious on changing values in demo.tfvars.

__Mandatory Values to Change__

```
account_id
aws_profile
```


## Step 3

Make sure you are in correct directory ie __iac__ and run the below command

```terraform init
   terraform plan -var-file=demo.tfvars
```

## Step 4 

Once the plan is successful run the below command to create the infra 

```
terraform apply -var-file=demo.tfvars -auto-approve

```

## Step 5 

Once all the resources have been created, check the output values and get the value for __alb-dns__

Load the ALB dns in the browser it will open the "Hello World" page.




## Pushing logs to cloudwatch

The cloudwatch agent configuration file is in path __iac/golden_image/script__ . We push 3 logs to cloudwatch ie nginx access and error logs and cloudwatch agent logs.

the log group names are

```/ec2/webserver/nginx/access
   /ec2/webservers/nginx/error
   /webserver/CloudWatchAgentLog
```


## Access to server for developers in case of issue.

We created the SSM inventory to login to server 

1. Configure the AWS profile using command

``` 
aws configure

```

2. Install the ssm plugin in host

   Steps to install [ssm-plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) 


2. Get the instance ID to login and run the below command 

```
aws ssm start-session --target <instance_id> --profile <profile_name> --region ap-southeast-2

```
