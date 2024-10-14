#!/bin/bash

# Export as environment variables
export APP_KAFKA_CLUSTER_API_KEY=$(terraform output -raw app_kafka_cluster_api_key)
export APP_KAFKA_CLUSTER_API_SECRET=$(terraform output -raw app_kafka_cluster_api_secret)
export APP_SCHEMA_REGISTRY_API_KEY=$(terraform output -raw app_schema_registry_api_key)
export APP_SCHEMA_REGISTRY_API_SECRET=$(terraform output -raw app_schema_registry_api_secret)
export SCHEMA_REGISTRY_URL=$(terraform output -raw schema_registry_rest_endpoint)
export KAFKA_BOOTSTRAP_SERVERS=$(terraform output -raw kafka_cluster_bootstrap_endpoint)

echo "Environment variables set:"
echo "SCHEMA_REGISTRY_URL=$SCHEMA_REGISTRY_URL"
echo "KAFKA_BOOTSTRAP_SERVERS=$KAFKA_BOOTSTRAP_SERVERS"
echo "App service acccount's api key and secret to access broker and schema registry"

# Now that the variables are present in the shell, run the app
(cd ./confluentcloud-streamingplatform-clientapp && ./gradlew bootRun --args="--spring.profiles.active=confluent")
