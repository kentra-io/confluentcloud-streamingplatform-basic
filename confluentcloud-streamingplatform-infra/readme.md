# Infra module
This repository is part of the confluentcloud-streamingplatform-basic project (see [main readme](../readme.md))

## Overview
This module is setting up an environment in [Confluent Cloud](http://confluent.cloud):
- Environment
- Kafka cluster with schema registry
- Two service accounts: 
  - playground_manager_sa
  - app_sa
- permissions for these accounts

For details check [main.tf](main.tf)
