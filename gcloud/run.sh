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
export cloudrun_east1=glau-retail-svc-east1
export cloudrun_west1=glau-retail-svc-west1

# Update env_vars_us_east1.yaml & env_vars_us_westt1.yaml before running the command below

./create_cloudrun.sh $app_image \
	$cloudrun_east1 $vpc_connector_east $cloudsql_master \
	$cloudrun_west1 $vpc_connector_west $cloudsql_replica

