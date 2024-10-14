terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.4.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.kafka_cluster_api_key
  cloud_api_secret = var.kafka_cluster_api_secret
}

locals {
  topics_data = yamldecode(file("${path.module}/topics.yaml"))

  # Flatten read permissions into a list of maps with topic and principal
  read_acls = flatten([
    for topic_name, topic_data in local.topics_data : [
      for principal in lookup(topic_data, "read_permissions", []) : {
        topic     = topic_name
        principal = principal
      }
    ]
  ])

  # Flatten write permissions into a list of maps with topic and principal
  write_acls = flatten([
    for topic_name, topic_data in local.topics_data : [
      for principal in lookup(topic_data, "write_permissions", []) : {
        topic     = topic_name
        principal = principal
      }
    ]
  ])
}

resource "confluent_kafka_topic" "topic" {
  for_each         = local.topics_data
  topic_name       = each.key
  partitions_count = each.value["partitions_count"]
  rest_endpoint    = var.kafka_rest_endpoint
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  credentials {
    key    = var.kafka_cluster_api_key
    secret = var.kafka_cluster_api_secret
  }
  config           = length(lookup(each.value, "config", {})) > 0 ? {
    for key, value in each.value["config"] : key => value
  } : {}
}

# Create read ACLs
resource "confluent_kafka_acl" "read_acl" {
  for_each = {
    for acl in local.read_acls : "${acl.topic}_${acl.principal}_read" => acl
  }

  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "${each.value.topic}"
  pattern_type  = "LITERAL"
  principal     = "User:${each.value.principal}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_rest_endpoint

  credentials {
    key    = var.kafka_cluster_api_key
    secret = var.kafka_cluster_api_secret
  }
}

# Create write ACLs
resource "confluent_kafka_acl" "write_acl" {
  for_each = {
    for acl in local.write_acls : "${acl.topic}_${acl.principal}_write" => acl
  }

  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "${each.value.topic}"
  pattern_type  = "LITERAL"
  principal     = "User:${each.value.principal}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.kafka_rest_endpoint

  credentials {
    key    = var.kafka_cluster_api_key
    secret = var.kafka_cluster_api_secret
  }
}
