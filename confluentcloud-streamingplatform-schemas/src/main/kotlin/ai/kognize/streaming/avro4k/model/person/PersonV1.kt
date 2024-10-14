package io.kentra.streaming.avro4k.model.person

import kotlinx.serialization.Serializable

@Serializable
data class PersonV1(
    val uuid: String,
    val name: String,
//    val age: Int? // simulating a scenario where this field was added in schema person-v1_1.avsc
)
