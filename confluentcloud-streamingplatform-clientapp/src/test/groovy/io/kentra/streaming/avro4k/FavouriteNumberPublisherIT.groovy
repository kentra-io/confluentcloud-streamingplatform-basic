package io.kentra.streaming.avro4k

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import io.kentra.streaming.avro4k.port.out.FavouriteNumberPublisher
import groovy.util.logging.Slf4j
import jakarta.annotation.PostConstruct
import org.spockframework.spring.SpringSpy
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Import
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component

@Import(FavouriteNumberTestListener)
class FavouriteNumberPublisherIT extends ITSpecification {
    @Autowired
    FavouriteNumberPublisher favouriteNumberPublisher

    @SpringSpy
    FavouriteNumberTestListener favouriteNumberListener

    def 'should publish a message and successfully receive it'() {
        given:
        var randomUUID = UUID.randomUUID().toString()
        var favouriteNumber = new FavouriteNumberV1(7, "bogdan", randomUUID)

        when:
        favouriteNumberPublisher.publish(favouriteNumber)
        Thread.sleep(1000L) // properly you'd use Awaitility but this is a simple example

        then:
        1 * favouriteNumberListener.receive(favouriteNumber)
    }
}

@Component
@Slf4j
class FavouriteNumberTestListener {
    @PostConstruct
    void init() {
        log.info("FavouriteNumberListener initialized")
    }

    @KafkaListener(topics = "\${kafka.topics.favourite-number}", groupId = "test-listener")
    void receive(FavouriteNumberV1 favouriteNumber) {
        log.info("Received favourite number in the test listener: {}", favouriteNumber)
    }
}
