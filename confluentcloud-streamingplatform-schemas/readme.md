# Template Schema repository for Avro4k
This repository is part of the confluentcloud-streamingplatform-basic project (see [main readme](../readme.md))

## About this repository
This is a template repository designed to store avro schemas of a domain. It's a POC and a part of the parent project, 
but can exist independently if tuned a bit.

It's built using Kotlin and Avro4k, but the presented approach is generic and can be implemented using any tech stack.

##  Flow
- Create an Avro4k class and a corresponding .avsc file (coherency validated in Avro4kSerializationTest)
- Publish it to the local maven repository so that you can use the Avro4k classes in your local kafka client application
- Add the .avsc to subject mapping in terraform/schemas.yaml
- Do `terraform apply` in the root module (full instruction in [main readme](../readme.md)). This will ensure coherency between 
the mapping in `schemas.yaml` and your confluent cloud schema registry instance

## How to use

### Adding a new Avro4k Schema
- Create a new Avro4k class and a corresponding .avsc file
- Add the pair to Avro4kSerializationTest to ensure coherency 
(upgrade idea: establish some convention / validation  that enforces that each Avro4k file is present in this test)

### Publishing the schemas to local maven repository
- `./gradlew publishToMavenLocal` (only local repo supported right now, this is a POC)

### Uploading the schema to your schema registry instance

#### Prework
- You need 2 env variables on your classpath:  TF_VAR_schema_registry_api_key, TF_VAR_schema_registry_api_secret
- To get values these, log into confluent cloud and generate the api key/secret pair for the  schema registry instance (upgrade idea: can you get a shared key?)
- Update the terraform.tfvars file with the schema registry url & id. It's present in the file you can download while creating the api key in confluent cloud

#### Activity per each schema
- Add the .avsc file path to the subject mapping in terraform/schema-assignment/schemas.yaml
- For non breaking changes modify the Avro4k class and add a new .avsc file
- For breaking changes you need to upgrade a major version of the Avro4k class (and add a new .avsc file as well)
- Do `terraform apply` in the terraform/schema-assignment module.
Make sure that in main.yaml 
