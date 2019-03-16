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

Also create a terraform.tfvars (gitignored) defining root variables. The
necessary variables are defined and documented in the root variables.tf.

For example:

```
ec2_key_pair_name = "my-ec2-keypair"
ec2_key_pair_private_path = "~/.ssh/my-ec2-keypair.pem"
source_ips_master = ["1.2.3.4/32"]
domain_name = "my.route53.domain"
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
    - ~~TLS to master~~
    - Use hardened base image for Jenkins
