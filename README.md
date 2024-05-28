# terraform-jenkins

## About This Repository
This repository contains automation to provision Jenkins on a single EC2 instance.

We create 2 subnets - 1 for Jenkins, 1 for our app (which is deployed as part of the `terraform-jpetstore` repo) - with the necessary resource to communicate between them.

## Requirements

* A bucket to store Terraform state (automation not contained with this repo). Place the arn of this bucket in your `terraform.tfvars`; see next section.
* An ssh key-pair available in AWS. Place name of this key-pair in your `terraform.tfvars`; see next section.

## Example terraform.tfvars

Create a `terraform.tfvars` file to assign values to the following variables:
```
project_name                = "ci-project-name"
project_owner               = "my-name"
ami_key_pair_name           = "my-keypair-name"
jenkins_admin_username      = "admin"
jenkins_admin_password      = "6c54A^c!#J6BYq*Ks2!x^QoA"
jenkins_tf_state_bucket_arn = "arn:aws:s3:::my-bucket-terraform-state"
```

## Provision

`terraform apply`
