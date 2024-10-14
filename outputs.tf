output "env_manager_schema_registry_key" {
    value = module.infra.playground_manager_sa.schema_registry_api_key
}

output "env_manager_schema_registry_secret" {
  value = module.infra.playground_manager_sa.schema_registry_api_secret
  sensitive = true
}

output "app_schema_registry_api_key" {
  value = module.infra.app_sa.schema_registry_api_key
}

output "app_schema_registry_api_secret" {
  value = module.infra.app_sa.schema_registry_api_secret
  sensitive = true
}

output "app_kafka_cluster_api_key" {
  value = module.infra.app_sa.kafka_api_key
}

output "app_kafka_cluster_api_secret" {
  value = module.infra.app_sa.kafka_api_secret
  sensitive = true
}

output "app_sa_id" {
  value = module.infra.app_sa.id
}

output "schema_registry_rest_endpoint" {
  value = module.infra.schema_registry.rest_endpoint
}

output "schema_registry_id" {
  value = module.infra.schema_registry.id
}

output "kafka_cluster_bootstrap_endpoint" {
  value = module.infra.kafka_cluster.bootstrap_endpoint
}
