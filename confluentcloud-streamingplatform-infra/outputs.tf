output "playground_manager_sa" {
  value = {
    kafka_api_key = confluent_api_key.playground_manager_kafka_api_key.id
    kafka_api_secret = confluent_api_key.playground_manager_kafka_api_key.secret
    schema_registry_api_key = confluent_api_key.playground_manager_schema_registry_api_key.id
    schema_registry_api_secret = confluent_api_key.playground_manager_schema_registry_api_key.secret
  }
  sensitive = true
}

output "app_sa" {
  value = {
    id = confluent_service_account.app_sa.id
    kafka_api_key = confluent_api_key.app_kafka_api_key.id
    kafka_api_secret = confluent_api_key.app_kafka_api_key.secret
    schema_registry_api_key = confluent_api_key.app_schema_registry_api_key.id
    schema_registry_api_secret = confluent_api_key.app_schema_registry_api_key.secret
  }
  sensitive = true
}

output "kafka_cluster" {
  value = {
    bootstrap_endpoint = confluent_kafka_cluster.playground_cluster.bootstrap_endpoint
    rest_endpoint = confluent_kafka_cluster.playground_cluster.rest_endpoint
    id = confluent_kafka_cluster.playground_cluster.id
  }
}

output "schema_registry" {
  value = {
    rest_endpoint = data.confluent_schema_registry_cluster.essentials.rest_endpoint
    id = data.confluent_schema_registry_cluster.essentials.id
  }
}
