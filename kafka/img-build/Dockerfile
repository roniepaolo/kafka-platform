FROM azul/zulu-openjdk-alpine:11-jre-latest

ENV KAFKA_VERSION=3.3.1 \
    SCALA_VERSION=2.13 \
    KAFKA_HOME=/kafka

RUN set -eux; \
    \
    apk add --no-cache --upgrade curl bash; \
    addgroup -g 1001 -S kafka; \
    adduser -G kafka -u 1001 -s /bin/bash -h $KAFKA_HOME -S -D kafka; \
    chmod 755 $KAFKA_HOME; \
    mkdir $KAFKA_HOME/data $KAFKA_HOME/logs; \
    \
    path=kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz; \
    curl -fsSL -o /tmp/kafka.tgz https://downloads.apache.org/$path || \
    curl -fsSL -o /tmp/kafka.tgz https://archive.apache.org/dist/$path; \
    \
    checksum=d14d9cc97d1702649b33378f38060c4a6220850a3d7182d1af20e905cb98728e51f2aeec63121f5773a389d6b66891b7508e5d23584dd1a4e424825e3d54e3e0; \
    echo "$checksum  /tmp/kafka.tgz" | sha512sum -c; \
    tar -xzf /tmp/kafka.tgz -C $KAFKA_HOME --strip-components 1; \
    \
    rm -rf /tmp/kafka.tgz $KAFKA_HOME/site-docs; \
    chown -R kafka:kafka $KAFKA_HOME

USER kafka

WORKDIR $KAFKA_HOME

EXPOSE 9092

COPY ./log4j.properties /kafka/config
COPY ./server.properties /kafka/config/kraft
COPY --chown=kafka:kafka ./cluster_id.txt /
COPY --chown=kafka:kafka ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
