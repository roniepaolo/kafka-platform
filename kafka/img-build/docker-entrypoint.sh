#!/bin/bash

set -eux

export KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"
./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ./config/kraft/server.properties
unset KAFKA_CLUSTER_ID

exec ./bin/kafka-server-start.sh ./config/kraft/server.properties

exec "$@"
