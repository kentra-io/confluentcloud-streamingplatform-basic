variable "schema_registry_api_key" {
  description = "Confluent Cloud Schema Registry API Key"
  type = string
  sensitive = true
}

variable "schema_registry_api_secret" {
  description = "Confluent Cloud Schema Registry API Secret"
  type = string
  sensitive = true
}

variable "schema_registry_id" {
  description = "Schema registry id (found in the file you can download when creating an api key under 'Resource' label)"
  type        = string
}

variable "schema_registry_rest_endpoint" {
  description = "Schema Registry REST Endpoint"
  type        = string
}
