package io.kentra.streaming.avro4k.port.out

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Component

@Component
class FavouriteNumberPublisher(
    val kafkaTemplate: KafkaTemplate<String, FavouriteNumberV1>
) {

    fun publish(favouriteNumber: FavouriteNumberV1) {
        kafkaTemplate.sendDefault(favouriteNumber).get()
    }


}
