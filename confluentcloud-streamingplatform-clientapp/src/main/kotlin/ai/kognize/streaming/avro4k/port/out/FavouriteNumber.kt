package io.kentra.streaming.avro4k.port.out

import kotlinx.serialization.Serializable

@Serializable
data class FavouriteNumber(
    val number: Int,
    val author: String,
    val uuid: String
)
