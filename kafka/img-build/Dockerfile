FROM azul/zulu-openjdk-alpine:11-jre-latest

ENV KAFKA_VERSION=3.3.2 \
    SCALA_VERSION=2.13 \
    KAFKA_HOME=/kafka \
    KAFKA_DATA=/kafka/data

RUN set -eux; \
    \
    apk add --no-cache --upgrade curl bash; \
    addgroup -g 1001 -S kafka; \
    adduser -G kafka -u 1001 -s /bin/bash -h $KAFKA_HOME -S -D kafka; \
    chmod 755 $KAFKA_HOME; \
    mkdir $KAFKA_DATA $KAFKA_HOME/logs; \
    \
    path=kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz; \
    curl -fsSL -o /tmp/kafka.tgz https://downloads.apache.org/$path || \
    curl -fsSL -o /tmp/kafka.tgz https://archive.apache.org/dist/$path; \
    \
    checksum=f56657105a67f6195c1d4795b5fb4a00fc5e2f5cce061d7f7a504063778187b325c6fbe51d7c59f57cd7ef323a37d4c2c780c27a5609a2008852cbfa944287b3; \
    echo "$checksum  /tmp/kafka.tgz" | sha512sum -c; \
    tar -xzf /tmp/kafka.tgz -C $KAFKA_HOME --strip-components 1; \
    \
    rm -rf /tmp/kafka.tgz $KAFKA_HOME/site-docs; \
    chown -R kafka:kafka $KAFKA_HOME

COPY log4j.properties $KAFKA_HOME/config

RUN mkdir $KAFKA_HOME/config.orig; \
    mv $KAFKA_HOME/config/* $KAFKA_HOME/config.orig; \
    chown -R kafka:kafka $KAFKA_HOME/config.orig; \
    chmod -R g+w,o+w $KAFKA_HOME

USER kafka

WORKDIR $KAFKA_HOME

EXPOSE 9092

VOLUME ["/kafka/data", "/kafka/logs", "/kafka/config"]

COPY --chown=kafka:kafka docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
