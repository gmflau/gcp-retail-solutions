#!/bin/bash


vpc_network=$1
neg_east=$2
cloudrun_east=$3
neg_west=$4
cloudrun_west=$5

gcloud compute network-endpoint-groups create $neg_east \
	--region=us-east1 \
	--network=$vpc_network \
	--network-endpoint-type=serverless \
	--cloud-run-service=$cloudrun_east

gcloud compute network-endpoint-groups create $neg_west \
        --region=us-west1 \
        --network=$vpc_network \
        --network-endpoint-type=serverless \
        --cloud-run-service=$cloudrun_west

