variable "kafka_rest_endpoint" {
  description = "Kafka cluster rest endpoint"
  type        = string
}

variable "kafka_cluster_id" {
  description = "Kafka cluster id"
  type        = string
}

variable "kafka_cluster_api_key" {
  type = string
}

variable "kafka_cluster_api_secret" {
  type = string
}

variable "schema_registry_endpoint" {
  description = "Schema registry rest endpoint"
  type        = string
}

variable "schema_registry_id" {
  description = "Schema registry id"
  type        = string
}

variable "schema_registry_api_key" {
  type = string
}

variable "schema_registry_api_secret" {
  type = string
}
