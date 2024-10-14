# Confluentcloud Infra repo - Playground cluster

## Overview
This repository is intended to:
- create the environment and cluster, to be managed by the platform team
- have a module where developers can manage topics through a yaml file

## When setting up:
1. Run `terraform apply` on the root module. Cluster, topics and ACLs will be created.
2. Update the service account id in ./terraform/environment/main.tf and ./terraform/topics/topics.yaml
3. Run `terraform apply` again in the infra repo
4. Run `terraform apply` in the schemas repo
5. Run `./gradlew bootRun --args="--spring.profiles.active=confluent"` in the scratchpad project after `source ~/.zshrc`
