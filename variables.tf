variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (needs scope Cloud resource management)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}
