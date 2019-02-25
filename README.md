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

## TODO

- Get a basic functioning setup on EC2
- Harden
