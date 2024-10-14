package io.kentra.streaming.avro4k.config

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.kafka.core.ProducerFactory

@Configuration
class KafkaConfiguration {

    @Bean
    fun kafkaTemplate(producerFactory: ProducerFactory<String, FavouriteNumberV1>,
                      @Value("\${kafka.topics.favourite-number}") favouriteNumberTopic: String): KafkaTemplate<String, FavouriteNumberV1> {
        KafkaTemplate(producerFactory).let {
            it.defaultTopic = favouriteNumberTopic
            return it
        }
    }
}
