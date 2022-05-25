gcloud compute networks create glau-retail-vpc \
	--subnet-mode=custom

gcloud compute networks subnets create us-east1-subnet \
	--network=glau-retail-vpc \
	--range=10.10.0.0/24 \
	--region=us-east1

gcloud compute networks subnets create us-west1-subnet \
        --network=glau-retail-vpc \
        --range=10.20.0.0/24 \
        --region=us-west1

gcloud compute networks vpc-access connectors create glau-vpc-access-us-east1 \
	--region us-east1 \
	--network glau-retail-vpc \
	--range 10.12.0.0/28

gcloud compute networks vpc-access connectors create glau-vpc-access-us-west1 \
        --region us-west1 \
        --network glau-retail-vpc \
        --range 10.22.0.0/28


