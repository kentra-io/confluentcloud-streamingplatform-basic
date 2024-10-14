package io.kentra.streaming.avro4k.port.out

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import io.github.oshai.kotlinlogging.KotlinLogging
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component

@Component
class FavouriteNumberListener {
    private val log = KotlinLogging.logger {}

    @KafkaListener(topics = ["\${kafka.topics.favourite-number}"])
    fun listen(favouriteNumber: FavouriteNumberV1) {
        log.info { "Received favourite number: $favouriteNumber" }
    }
}
