package io.kentra.streaming.avro4k

import io.kentra.streaming.avro4k.model.favourite_number.FavouriteNumberV1
import io.kentra.streaming.avro4k.model.person.PersonV1
import com.fasterxml.jackson.databind.ObjectMapper
import com.github.avrokotlin.avro4k.Avro
import com.github.avrokotlin.avro4k.schema
import kotlinx.serialization.KSerializer
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.Arguments
import org.junit.jupiter.params.provider.MethodSource
import java.util.stream.Stream

class Avro4kSerializationTest {
    @ParameterizedTest
    @MethodSource("provideAvro4kClassAndSchemaPairs")
    fun `Should serialize to expected avro schema`(
        avro4kSerializer: KSerializer<*>,
        avroSchemaResourcePath: String
    ) {
        val schema = Avro.schema(avro4kSerializer)
        val schemaJson = schema.toString()
        println(schemaJson)

        val expectedSchemaJson = Avro4kSerializationTest::class.java.getResource("/schemas/$avroSchemaResourcePath")!!.readText()
        assertJsonEquals(expectedSchemaJson, schemaJson)
    }

    companion object {
        @JvmStatic
        private fun provideAvro4kClassAndSchemaPairs(): Stream<Arguments> {
            return Stream.of(
                Arguments.of(FavouriteNumberV1.serializer(), "favourite-number/favourite-number-v1_0.avsc"),
                Arguments.of(PersonV1.serializer(), "person/person-v1_1.avsc")
            )
        }
    }

    private fun assertJsonEquals(expected: String, actual: String) {
        val mapper = ObjectMapper();
        val expectedJson = mapper.readTree(expected)
        val actualJson = mapper.readTree(actual)
        assertEquals(expectedJson, actualJson)
    }
}
