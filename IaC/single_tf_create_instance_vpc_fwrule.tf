# Main.tf
# This is a single Terraform (GCP) file for creating
# 1 - VPC Network : ahsancorp-vpc-2
# 2 - Subnets x3 singapore-1, singapore-1, finland-1
# 3 - Firewall rule for ICMP, Web and SSH ports in the VPN from any source 0.0.0.0
# 4 - Create 3 VM Instances with network to VPC in item 1 and one subnet each
#
# Change the file name to main.tf
# change 
# <Your GCP ProjectID> to your GCP project ProjectID
# 
# Author: Muhammad Nauman Yousuf
# Last Modiifed: 07-Nov-22
# Change Log:

locals{
    project = "<Your GCP ProjectID>"
    region = "us-east1"
}


provider "google" {
	#Using the Google Cloud Shell it is observed that using absolute path works fine 
    credentials = ("key.json")
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
                subnet_name           = "singapore-1"
                subnet_ip             = "49.49.49.0/24"
                subnet_region         = "europe-west3"
                subnet_flow_logs      = "false"
                privateIpGoogleAccess = "true"
                stackType             = "IPV4_ONLY"
                description           = "This subnet is part of main VPN ahsan for German area"
            },
            {
                subnet_name           = "finland-1"
                subnet_ip             = "45.45.45.0/24"
                subnet_region         = "europe-north1"
                subnet_flow_logs      = "false"
                privateIpGoogleAccess = "true"
                stackType             = "IPV4_ONLY"
                description           = "This subnet is part of main VPN ahsan for Finland area"
            }
        ]#eo subnet
} #EO module VPC 


#################### VPC - sub-group - Firewalls ####################

resource "google_compute_firewall" "ahsancorp-fwrule-allow" {
  name    = "ahsancorp-fwrule-allow"
 network = "projects/<Your GCP ProjectID>/global/networks/ahsancorp-vpc-2"

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "ayaan-instance-1" {
  name         = "ayaan-instance-1"
  machine_type = "n1-standard-2"
  zone         = "asia-southeast1-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "ahsancorp-vpc-2"
    subnetwork = "singapore-1"
  }
}


resource "google_compute_instance" "ayaan-sg-instance-2" {
  name         = "ayaan-sg-instance-2"
  machine_type = "n1-standard-1"
  zone         = "asia-southeast1-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "ahsancorp-vpc-2"
    subnetwork = "singapore-1"
  }
}

resource "google_compute_instance" "ayaan-de-instance-3" {
  name         = "ayaan-de-instance-3"
  machine_type = "n1-standard-1"
  zone         = "europe-west3-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "ahsancorp-vpc-2"
    subnetwork = "germany-1"
  }
}

resource "google_compute_instance" "ayaan-fin-instance-4" {
  name         = "ayaan-fin-instance-4"
  machine_type = "n1-standard-1"
  zone         = "europe-north1-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "ahsancorp-vpc-2"
    subnetwork = "finland-1"
  }
}

