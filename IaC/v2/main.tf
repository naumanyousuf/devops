# Main.tf
#
#
# Author: Muhammad Nauman Yousuf
# Last Modiifed: 07-Nov-22
# Change Log:


provider "google" {
	#Using the Google Cloud Shell it is observed that using absolute path works fine 
    credentials = ("/credential-file.json")
    project = local.project
    region = local.region
}



#################### VPC - ahsancorp-vpc-2 - with 2 subnets ####################

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


#################### VPC - sub-group - Firewalls ####################

resource "google_compute_firewall" "tf-firewall" {
  name    = "ahsancorp-fwrule-allow-port-80"
 network = "projects/<PROJECT_ID>/global/networks/terraform-vpc"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}

module "instances" {
  source     = "./instances"
}