## In this demo we are creating the infrastructure in AWS cloud using Terraform.

Prereq

1. Need to have Terraform installed in the host where you are trying to recreate infra.

    Guidance to install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. Need to have packer installed in the host 

    Guidance to install [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)

3. Need to install and configure awc cli and aws profile to authenitcate AWS cloud. The profile should have all the necessary access to create resources in AWS cloud

    Guidance to install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

    Guidance to configure [aws-profile](https://docs.aws.amazon.com/toolkit-for-visual-studio/latest/user-guide/keys-profiles-credentials.html)


## Authentication with AWS Cloud

Any IaC tool needs to have authentication with the AWS cloud to build, provision and deploy the application service. Here we are about to discuss the two authentication approaches to build and deploy the application.

### Approach 1 - Run Terraform command in an EC2 instance 


Create an IAM role and attach necessary policies to create infra.


Launch an ec2 instance in AWS and install all the package dependencies (terraform, awscli, packer) and make sure this EC2 instance is attached with the above IAM role which we created.

We need to integrate this EC2 machine with our CI/CD tool hence we can deploy the infra


## Approch 2 - By using local aws profile authentication

Create an IAM bot user with programmatic access. Create a IAM profile in the local and configure the same profile in terraform script.

In this demo we are aligned with approach 2

### Directory Structure

We are created all the configurstion files in __iac__ folder

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

In this demo we not locking the terraform statefile. If you want to have the locking mechanism. Create a S3 buckek and dynamo DB table and uncomment the below lines in the __/iac/main.tf__ file

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
