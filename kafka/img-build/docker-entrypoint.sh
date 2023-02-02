#!/bin/bash

set -eux

kraft_logs=/kafka/data/kraft-combined-logs

if [ -z "$(ls -A $kraft_logs)" ]; then
  export KAFKA_CLUSTER_ID="$(< /cluster_id.txt)"
  ./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ./config/kraft/server.properties
  unset KAFKA_CLUSTER_ID
fi

exec ./bin/kafka-server-start.sh ./config/kraft/server.properties

exec "$@"
