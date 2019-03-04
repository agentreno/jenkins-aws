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
name of it when you run terraform. Ensure you have ssh-agent running and the
key pair shows up in `ssh-add -L`.

Also set default variables in `terraform-jenkins-aws/variables.tf`,
particularly the `ec2_key_pair_name`, `ec2_key_pair_private_path` and
`source_ips_master` to your own EC2 key pair details and current IP address.
For example:

```
# Pre-existing EC2 key pair to be used for access to instances
variable "ec2_key_pair_name" {
    type = "string"
    default = "my-ec2-keypair"
}

variable "ec2_key_pair_private_path" {
    type = "string"
    default = "~/.ssh/my-ec2-keypair.pem"
}

# Source IP ranges to allow HTTP and SSH to master
variable "source_ips_master" {
    type = "list"
    default = ["1.2.3.4/32"]
}
```

From the `terraform-jenkins-aws` directory, to build the project, run a plan
and check the actions that will be performed. Then run an apply:

```
terraform plan
terraform apply
```

Terraform will output a URL to access the Jenkins master, and the initial
administrator password..

## TODO

- ~~Get a basic functioning setup on EC2~~
- Add a simple ASG setup (as instances can be killed)
- Add remote S3 state for terraform
- Add Packer AMIs for master and slave
- Add startup groovy script to set Master executors to 0
- Test JNLP slave to master registration instead of SSH slaves
    - Start by enabling TCP port for JNLP agents under global security settings
    - Then add a new node as permanent agent with launch method of java web
      start and note secret
    - Try running a jenkins/jnlp-slave container on slave EC2 and connect with
      secret
- Add security tool integrations
    - Network connectivity to corporate network
- Harden the infrastructure and Jenkins instances
    - Security groups for network lockdown
    - Jenkins hardening (plugins, config, authn, authz etc.)
    - TLS to master
    - Use hardened base image for Jenkins
