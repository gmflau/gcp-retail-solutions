#!/bin/bash

export cloudsql_master=glau-retail-product-master
export cloudsql_replica=glau-retail-product-replica

export vpc_network=glau-retail-vpc
export vpc_subnet_east=glau-retail-vpc-us-east1-subnet
export vpc_connector_east=glau-retail-vpc-us-east1
export vpc_subnet_west=glau-retail-vpc-us-west1-subnet
export vpc_connector_west=glau-retail-vpc-us-west1

./create_vpc.sh $vpc_network $vpc_subnet_east $vpc_connector_east $vpc_subnet_west $vpc_connector_west

