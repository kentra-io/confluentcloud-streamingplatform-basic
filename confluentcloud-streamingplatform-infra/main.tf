terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.4.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "playground" {
  display_name = "Playground"

  stream_governance {
    package = "ESSENTIALS"
  }
}

resource "confluent_kafka_cluster" "playground_cluster" {
  display_name = "Playground cluster"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "eu-central-1"
  basic {}
  environment {
    id = confluent_environment.playground.id
  }
}

data "confluent_schema_registry_cluster" "essentials" {
  environment {
    id = confluent_environment.playground.id
  }

  depends_on = [
    confluent_kafka_cluster.playground_cluster
  ]
}

resource "confluent_service_account" "playground_manager" {
  display_name = "playground_manager_sa"
  description  = "Service account to manage the ${confluent_environment.playground.display_name} environment"
}

resource "confluent_role_binding" "playground_environment_admin" {
  principal   = "User:${confluent_service_account.playground_manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.playground.resource_name
}

resource "confluent_role_binding" "playground_manager_kafka_cluster_admin" {
  principal   = "User:${confluent_service_account.playground_manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.playground_cluster.rbac_crn
}

resource "confluent_service_account" "app_sa" {
  display_name = "app_playground_sa"
  description = "Service account for the application using the ${confluent_kafka_cluster.playground_cluster.display_name} cluster"
}

resource "confluent_role_binding" "app_sa_read_schemas" {
  principal   = "User:${confluent_service_account.app_sa.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${data.confluent_schema_registry_cluster.essentials.resource_name}/subject=*"
}

resource "confluent_kafka_acl" "app_sa_read_consumer_groups" {
  kafka_cluster {
    id = confluent_kafka_cluster.playground_cluster.id
  }
  resource_type = "GROUP"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.app_sa.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.playground_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.playground_manager_kafka_api_key.id
    secret = confluent_api_key.playground_manager_kafka_api_key.secret
  }
}

resource "confluent_api_key" "playground_manager_kafka_api_key" {
  display_name = "app_kafka_manager_api_key"
  description = "Kafka API key for the ${confluent_service_account.playground_manager.display_name} service account"
  owner {
    id          = confluent_service_account.playground_manager.id
    api_version = confluent_service_account.playground_manager.api_version
    kind        = confluent_service_account.playground_manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.playground_cluster.id
    api_version = confluent_kafka_cluster.playground_cluster.api_version
    kind        = confluent_kafka_cluster.playground_cluster.kind
    environment {
      id = confluent_environment.playground.id
    }
  }
}

resource "confluent_api_key" "playground_manager_schema_registry_api_key" {
  display_name = "app_schema_registry_manager_api_key"
  description = "Schema Registry API key for the ${confluent_service_account.playground_manager.display_name} service account"
  owner {
    id          = confluent_service_account.playground_manager.id
    api_version = confluent_service_account.playground_manager.api_version
    kind        = confluent_service_account.playground_manager.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.essentials.id
    api_version = data.confluent_schema_registry_cluster.essentials.api_version
    kind        = data.confluent_schema_registry_cluster.essentials.kind
    environment {
      id = confluent_environment.playground.id
    }
  }
}

resource "confluent_api_key" "app_kafka_api_key" {
  display_name = "app_kafka_api_key"
  description = "Kafka API key for the ${confluent_service_account.app_sa.display_name} service account"
  owner {
    id          = confluent_service_account.app_sa.id
    api_version = confluent_service_account.app_sa.api_version
    kind        = confluent_service_account.app_sa.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.playground_cluster.id
    api_version = confluent_kafka_cluster.playground_cluster.api_version
    kind        = confluent_kafka_cluster.playground_cluster.kind
    environment {
      id = confluent_environment.playground.id
    }
  }
}

resource "confluent_api_key" "app_schema_registry_api_key" {
  display_name = "app_schema_registry_api_key"
  description = "Schema Registry API key for the ${confluent_service_account.app_sa.display_name} service account"
  owner {
    id          = confluent_service_account.app_sa.id
    api_version = confluent_service_account.app_sa.api_version
    kind        = confluent_service_account.app_sa.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.essentials.id
    api_version = data.confluent_schema_registry_cluster.essentials.api_version
    kind        = data.confluent_schema_registry_cluster.essentials.kind
    environment {
      id = confluent_environment.playground.id
    }
  }
}
