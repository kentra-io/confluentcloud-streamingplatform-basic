package io.kentra.streaming.avro4k.model.favourite_number

import kotlinx.serialization.Serializable

@Serializable
data class FavouriteNumberV1(
    val number: Int,
    val author: String,
    val uuid: String
)
