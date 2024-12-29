package io.kentra.streaming.avro4k.port.out

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Component
import java.time.Instant

@Component
class FavouriteNumberPublisher(
    val kafkaTemplate: KafkaTemplate<String, FavouriteNumberV1>
) {

    fun publish(favouriteNumber: FavouriteNumberV1) {
        val timestampKey = Instant.now().toEpochMilli().toString()
        kafkaTemplate.sendDefault(timestampKey, favouriteNumber).get()
    }


}
