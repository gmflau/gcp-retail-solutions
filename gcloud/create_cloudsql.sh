#!/bin/bash

cloudsql_master=$1
cloudsql_replica=$2

gcloud beta sql instances create $cloudsql_master \
	--cpu=2 --memory=4GB \
	--assign-ip \
	--availability-type=regional \
	--enable-bin-log \
	--database-version=MYSQL_8_0 \
	--network=glau-vpc-network \
	--root-password=redis \
	--storage-size=10 \
	--storage-type=SSD \
	--region=us-east1

gcloud sql instances create $cloudsql_replica \
        --master-instance-name=$cloudsql_master \
        --region=us-west1

