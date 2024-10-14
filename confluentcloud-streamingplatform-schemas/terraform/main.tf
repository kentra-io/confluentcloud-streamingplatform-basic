terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">=1.0.0"
    }
  }
}

provider "confluent" {
  schema_registry_api_key = var.schema_registry_api_key
  schema_registry_api_secret = var.schema_registry_api_secret

  schema_registry_rest_endpoint = var.schema_registry_rest_endpoint
  schema_registry_id = var.schema_registry_id
}

# Read and decode YAML file
locals {
  subjects_data = yamldecode(file("${path.module}/schemas.yaml"))

  # Flatten the schema data to associate schemas with their subjects
  schemas_list = flatten([
    for subject_map in local.subjects_data.subjects : [
      for schema_file in subject_map.schema_files : {
        subject       = subject_map.name
        schema_file   = schema_file
      }
    ]
  ])
}

# Create subjects with compatibility level
resource "confluent_subject_config" "subjects" {
  for_each = {
    for subject in local.subjects_data.subjects :
    subject.name => subject
  }

  subject_name   = each.value.name
  compatibility_level  = each.value.compatibility

  schema_registry_cluster {
    id = var.schema_registry_id
  }
}

# Upload schemas to their respective subjects
resource "confluent_schema" "schemas" {
  for_each = {
    for schema in local.schemas_list :
    "${schema.subject}_${basename(schema.schema_file)}" => schema
  }

  subject_name  = each.value.subject
  format        = "AVRO"
  schema        = file("${path.module}/../src/main/resources/schemas/${each.value.schema_file}")

  schema_registry_cluster {
    id = var.schema_registry_id
  }
}
