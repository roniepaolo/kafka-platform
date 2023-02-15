ARG KAFKA_IMAGE
FROM $KAFKA_IMAGE as connect_base

EXPOSE 8083
VOLUME ["/kafka/data", "/kafka/logs", "/kafka/config"]

COPY --chown=kafka:kafka docker-entrypoint.sh /
COPY --chown=kafka:kafka log4j.properties $KAFKA_HOME/config
COPY docker-maven-download.sh /usr/local/bin/docker-maven-download

USER root

RUN chmod +x /docker-entrypoint.sh /usr/local/bin/docker-maven-download

USER kafka

ENV KAFKA_CONNECT_PLUGINS_DIR=$KAFKA_HOME/connect \
    EXTERNAL_LIBS_DIR=$KAFKA_HOME/external_libs \
    CONNECT_PLUGIN_PATH=$KAFKA_CONNECT_PLUGINS_DIR \
    MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs \
    APICURIO_VERSION=2.2.5.Final \
    CONFLUENT_VERSION=7.3.1 \
    AVRO_VERSION=1.9.2 \
    AVRO_JACKSON_VERSION=2.14.2 \
    KAFKA_CONNECT_AVRO_CONVERTER_MD5=b6f3b7e63dca16e327f6f9a7e9b1d9aa \
    KAFKA_CONNECT_AVRO_DATA_MD5=bd14fd74cdc0b39ba804cc8b46215759 \
    KAFKA_AVRO_SERIALIZER_MD5=ac384251e11d31045f0c48be539e60ae \
    KAFKA_SCHEMA_SERIALIZER_MD5=7b57801bfeef3bb7179b34793ce3d208 \
    KAFKA_SCHEMA_REGISTRY_CLIENT_MD5=44948bfe61ce00679e7ba1a3287fff3d \
    COMMON_CONFIG_MD5=e9ba5dc8c78fc0c169776d895ac3868d \
    COMMON_UTILS_MD5=6b80623df81001b0c35ecaa8057d87a2 \
    AVRO_MD5=cb70195f70f52b27070f9359b77690bb \
    JACKSON_CORE_ASL_MD5=6ee422ee4c481b2d5aacb2b5e36a7dc0 \
    JACKSON_CORE_DATABIND_MD5=c1b12dd14734cd1986132bf55042dd7e \
    JACKSON_CORE_ANNOTATIONS_MD5=10d19982a8890f6eb37557af2f58e272 \
    APICURIO_MD5=f7874b2e2a59dfa829242d9a52b44230

RUN mkdir "$KAFKA_CONNECT_PLUGINS_DIR" "$EXTERNAL_LIBS_DIR"

RUN set -eux; \
    \
    docker-maven-download confluent kafka-connect-avro-converter \
        "$CONFLUENT_VERSION" "$KAFKA_CONNECT_AVRO_CONVERTER_MD5"; \
    docker-maven-download confluent kafka-connect-avro-data \
        "$CONFLUENT_VERSION" "$KAFKA_CONNECT_AVRO_DATA_MD5"; \
    docker-maven-download confluent kafka-avro-serializer \
        "$CONFLUENT_VERSION" "$KAFKA_AVRO_SERIALIZER_MD5"; \
    docker-maven-download confluent kafka-schema-serializer \
        "$CONFLUENT_VERSION" "$KAFKA_SCHEMA_SERIALIZER_MD5"; \
    docker-maven-download confluent kafka-schema-registry-client \
        "$CONFLUENT_VERSION" "$KAFKA_SCHEMA_REGISTRY_CLIENT_MD5"; \
    docker-maven-download confluent common-config \
        "$CONFLUENT_VERSION" "$COMMON_CONFIG_MD5"; \
    docker-maven-download confluent common-utils \
        "$CONFLUENT_VERSION" "$COMMON_UTILS_MD5"; \
    docker-maven-download central org/apache/avro avro \
        "$AVRO_VERSION" "$AVRO_MD5"; \
    docker-maven-download central com/fasterxml/jackson/core jackson-core \
        "$AVRO_JACKSON_VERSION" "$JACKSON_CORE_ASL_MD5"; \
    docker-maven-download central com/fasterxml/jackson/core jackson-databind \
        "$AVRO_JACKSON_VERSION" "$JACKSON_CORE_DATABIND_MD5"; \
    docker-maven-download central com/fasterxml/jackson/core jackson-annotations \
        "$AVRO_JACKSON_VERSION" "$JACKSON_CORE_ANNOTATIONS_MD5"; \
    docker-maven-download apicurio \
        "$APICURIO_VERSION" "$APICURIO_MD5"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]

FROM connect_base as connect

ENV DEBEZIUM_VERSION=2.1.2.Final \
    MAVEN_CONNECT_JDBC_VERSION=10.6.1 \
    MONGODB_MD5=a1f4ae834a7e7b935324648b47832b93 \
    MYSQL_MD5=a0f00ed38a9525592a52e84efae1c415 \
    POSTGRES_MD5=ccaadb12b962a4dae6147534e1bfbe0b \
    SQLSERVER_MD5=ca85e2cf04a29f239718469b48c82539 \
    ORACLE_MD5=cf4378a79da596f86346113280bffd02 \
    DB2_MD5=8afc22d095572a9d4db5cbc2705d4416 \
    MAVEN_CONNECT_JDBC_MD5=713b4780b0856593fddc4a4fec48e90c

WORKDIR $KAFKA_CONNECT_PLUGINS_DIR

RUN set -eux; \
    \
    docker-maven-download debezium mongodb \
        "$DEBEZIUM_VERSION" "$MONGODB_MD5"; \
    docker-maven-download debezium mysql \
        "$DEBEZIUM_VERSION" "$MYSQL_MD5"; \
    docker-maven-download debezium postgres \
        "$DEBEZIUM_VERSION" "$POSTGRES_MD5"; \
    docker-maven-download debezium sqlserver \
        "$DEBEZIUM_VERSION" "$SQLSERVER_MD5"; \
    docker-maven-download debezium-incubator oracle \
        "$DEBEZIUM_VERSION" "$ORACLE_MD5"; \
    docker-maven-download debezium-incubator db2 \
        "$DEBEZIUM_VERSION" "$DB2_MD5"; \
    docker-maven-download confluent kafka-connect-jdbc \
        "$MAVEN_CONNECT_JDBC_VERSION" "$MAVEN_CONNECT_JDBC_MD5"

