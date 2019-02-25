# jenkins-aws-prototype

## Description

Jenkins running on AWS EC2 in a master-slave setup. Uses terraform to create
AWS resources and Packer to pre-install Jenkins plugins.

### Security goals

- Add security tool integrations to a Jenkins pipeline
  - Checkmarx
  - AppSpider
  - BlackDuck
- Limit network communications master to slave, and into master
- Install jenkins plugins that enhance security
- Use a small subset of whitelisted Jenkins plugins

## Building

Infrastructure is created using Terraform. If this is your first time in the
project, `cd terraform-jenkins-aws` and `terraform init`.

If you don't already have an EC2 key pair, create one, you'll be asked for the
name of it when you run terraform.

From the `terraform-jenkins-aws` directory, to build the project, run a plan
and check the actions that will be performed. Then run an apply:

```
terraform plan
terraform apply
```

Terraform will output a URL to access the Jenkins master.

## TODO

- Get a basic functioning setup on EC2
- Add remote S3 state for terraform
- Add Packer AMIs for master and slave
- Add security tool integrations
	- Network connectivity to corporate network
- Harden the infrastructure and Jenkins instances
	- Security groups for network lockdown
	- Jenkins hardening (plugins, config, authn, authz etc.)
	- TLS to master
	- Use hardened base image for Jenkins
