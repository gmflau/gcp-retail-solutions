#!/bin/bash


gcloud run deploy glau-retail-svc-us-east1 \
	--region=us-east1 \
	--image=gcr.io/central-beach-194106/glau-retail-redis \
	--port=8080 \
	--env-vars-file=env_vars_us_east1.yaml \
	--add-cloudsql-instances=glau-retail-product-master \
	--vpc-connector=glau-vpc-access-us-east1 \
	--allow-unauthenticated

gcloud run deploy glau-retail-svc-us-east1 \
	--region=us-west1
        --image=gcr.io/central-beach-194106/glau-retail-redis \
        --port=8080 \
        --env-vars-file=env_vars_us_west1.yaml \
        --add-cloudsql-instances=glau-retail-product-replica \
        --vpc-connector=glau-vpc-access-us-west1 \
        --allow-unauthenticated


