# Generating cluster ID
In order to generate the unique and [inmutable identifier of the cluster](https://kafka.apache.org/documentation/#impl_clusterid) execute the command `cat /proc/sys/kernel/random/uuid | tr -d '-' | base64 | cut -b 1-22 > cluster_id.txt`. This command must be executed before building the Dockerfile.
