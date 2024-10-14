package io.kentra.streaming.avro4k

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import io.kentra.streaming.avro4k.port.out.FavouriteNumberPublisher
import io.github.oshai.kotlinlogging.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.stereotype.Component
import java.util.UUID

@SpringBootApplication
class App

fun main(args: Array<String>) {
    runApplication<App>(*args)
}

@Component
class publishingRunner(
    @Autowired
    val publisher: FavouriteNumberPublisher
) : CommandLineRunner{
    val log = KotlinLogging.logger {}
    override fun run(vararg args: String?) {
        log.info {"Publishing favourite number"}
        publisher.publish(FavouriteNumberV1(42, "Lem", UUID.randomUUID().toString()))
    }
}
