# single terraform file for creating Custom Mode VPC Network with 2 different subnet
# and
# two VM instances
#
#
# Author: Muhammad Nauman Yousuf
# Last Modiifed: 21-Oct-22
# Change Log:
# 21Oct22 Corrected IP Address range


locals {
    #Name of project NOT ID
    project = "project-name-goes-here"
    region = "1"
}

provider "google" {
	#Using the Google Cloud Shell it is observed that using absolute path works fine 
    credentials = ("/credential-file.json")
    project = local.project
    region = local.region
}


##Creating VPC and subnets

module "vpc" {
        source  = "terraform-google-modules/network/google"
        version = "~> 4.0"

        project_id   = local.project
        network_name = "ahsancorp-vpc-2"
        routing_mode = "REGIONAL"

        subnets = [
            {
                subnet_name           = "singapore-1"
                subnet_ip             = "65.65.65.0/24"
                subnet_region         = "asia-southeast1"
                subnet_flow_logs      = "false"
                privateIpGoogleAccess = "true"
                stackType             = "IPV4_ONLY"
                description           = "This subnet is part of main VPN ahsan for Singapore area"
            },
            {
                subnet_name           = "germany-1"
                subnet_ip             = "49.49.49.0/24"
                subnet_region         = "europe-west3"
                subnet_flow_logs      = "false"
                privateIpGoogleAccess = "true"
                stackType             = "IPV4_ONLY"
                description           = "This subnet is part of main VPN ahsan for German area"
            }
        ]

} #EO module VPC 

