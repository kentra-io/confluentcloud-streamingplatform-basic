# Confluent Cloud kafka client app
This repository is part of the confluentcloud-streamingplatform-basic project (see [main readme](../readme.md))

## About this module
This is a sample client app that will pull the schema library from your maven repo and use it to publish and consume 
messages from your kafka cluster deployed to [Confluent Cloud](confluent.cloud)

This repository has slightly been adapted for the purpose of this project, but it's heavily based on a sample repo I created: https://github.com/kentra-io/kotlin-testcontainers-kafka-avro4k in which I cover it more deeply

## How to use

### Running locally with docker-compose
```
./docker-compose up
./gradlew bootRun --args='--spring.profiles.active=local' 
```
### Running with testcontainers
`./gradlew test`
### Running locally with confluent cloud
Full instruction in [main readme](../readme.md#how-to-use). Before running this app, you need to provision your confluent cloud
environment first, publish your schema library to your local maven repo and set the appropriate env variables required by
the [confluent profile](src/main/resources/application-confluent.yaml).

After this is done, the schema is present in your local maven repo and correct env variables are present in your shell, 
you can run the app with `confluent` profile: 

`./gradlew bootRun --args='--spring.profiles.active=confluent' `

## Used technologies
- Kotlin
- Avro4k
- Testcontainers
- Spock (unnecessarily complicates this repo and doesn't bring value to this example, I added it when I was building something else but then decided to publish this repo)
