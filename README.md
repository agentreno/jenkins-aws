# jenkins-aws-prototype

## Description

Container Jenkins running on ECS Fargate in a master-slave setup. Uses
terraform to create AWS resources and custom Dockerfiles to install Jenkins
plugins.

### Security goals

- Add security tool integrations to a Jenkins pipeline
  - Checkmarx
  - AppSpider
  - BlackDuck
- Limit network communications master to slave, and into master
- Install jenkins plugins that enhance security
- Use a small subset of whitelisted Jenkins plugins

## TODO

- Create local environment with docker-compose
- Get a basic functioning setup on Fargate
