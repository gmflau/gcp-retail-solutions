#!/bin/bash

set -ex


export cloudsql_master=glau-retail-product-master-09
export cloudsql_replica=glau-retail-product-replica-09
export vpc_network=glau-retail-vpc-09
export vpc_subnet_east=glau-retail-vpc-us-east1-09
export vpc_connector_east=glau-retail-us-east1-09
export vpc_subnet_west=glau-retail-vpc-us-west1-09
export vpc_connector_west=glau-retail-us-west1-09


# Create VPC network, VPC subnets, VPC connector
./create_vpc.sh $vpc_network $vpc_subnet_east $vpc_connector_east $vpc_subnet_west $vpc_connector_west

# Create CloudSQL (MySQL) Master/Replica
./create_cloudsql.sh $cloudsql_master $cloudsql_replica

# Populate product db
./product_db.sh $cloudsql_master


#
# Peer with Redis Active/Active VPC
# project id: central-beach-194106
#

#
# git clone the repo
# cd cloudrun-redis
# Run $ gcloud builds submit --tag gcr.io/central-beach-194106/glau-retail-redis
#


export app_image=gcr.io/central-beach-194106/glau-retail-redis
export cloudrun_east=glau-retail-svc-east1-09
export cloudrun_west=glau-retail-svc-west1-09

# Update env_vars_us_east1.yaml & env_vars_us_westt1.yaml before running the command below

./create_cloudrun.sh $app_image \
	$cloudrun_east1 $vpc_connector_east $cloudsql_master \
	$cloudrun_west1 $vpc_connector_west $cloudsql_replica


#
# Create load balancer & components
#
export neg_east=glau-retail-neg-east
export neg_west=glau-retail-neg-west

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


#
# Create backend service
#

export lb_ipv4=glau-retail-lb-ip-09
gcloud compute addresses create $lb_ipv4 \
	--ip-version=IPV4 \
	--network-tier=PREMIUM \
	--global

# gcloud compute addresses describe $lb_ipv4 \
# --format="get(address)" \
# --global


export backend_svc=glau-retail-backend-svc-09

gcloud compute backend-services create $backend_svc \
	--global
#	--protocol=HTTPS \
#	--port-name=

gcloud compute backend-services add-backend $backend_svc \
	--network-endpoint-group=$neg_east \
	--network-endpoint-group-region=us-east1 \
	--global
	
gcloud compute backend-services add-backend $backend_svc \
        --network-endpoint-group=$neg_west \
        --network-endpoint-group-region=us-west1 \
        --global

export url_map=glau-retail-lb-09
gcloud compute url-maps create $url_map \
	--default-service=$backend_svc \
	--global

export http_lb_proxy=glau-retail-http-lb-proxy-09
gcloud compute target-http-proxies create $http_lb_proxy \
	--url-map=$url_map

export http_content_rule=glau-retail-http-content-rule-09
gcloud compute forwarding-rules create http-content-rule \
	--load-balancing-scheme=EXTERNAL \
	--address=$lb_ipv4 \
	--global \
	--target-http-proxy=$http_lb_proxy \
	--ports=80
