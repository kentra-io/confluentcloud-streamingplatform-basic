terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.4.0"
    }
  }
}

provider "confluent" {
  cloud_api_key = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

module "infra" {
  source = "./confluentcloud-streamingplatform-infra"
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
}

module "topics" {
  source = "./confluentcloud-streamingplatform-topics"

  kafka_rest_endpoint = module.infra.kafka_cluster.rest_endpoint
  kafka_cluster_id = module.infra.kafka_cluster.id
  kafka_cluster_api_key = module.infra.playground_manager_sa.kafka_api_key
  kafka_cluster_api_secret = module.infra.playground_manager_sa.kafka_api_secret
  schema_registry_endpoint = module.infra.schema_registry.rest_endpoint
  schema_registry_id = module.infra.schema_registry.id
  schema_registry_api_key = module.infra.playground_manager_sa.schema_registry_api_key
  schema_registry_api_secret = module.infra.playground_manager_sa.schema_registry_api_secret
}

module "schemas" {
  source = "./confluentcloud-streamingplatform-schemas/terraform"

  schema_registry_id = module.infra.schema_registry.id
  schema_registry_rest_endpoint = module.infra.schema_registry.rest_endpoint
  schema_registry_api_key = module.infra.playground_manager_sa.schema_registry_api_key
  schema_registry_api_secret = module.infra.playground_manager_sa.schema_registry_api_secret
}
