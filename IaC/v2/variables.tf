# variables.tf
#
#
# Author: Muhammad Nauman Yousuf
# Last Modiifed: 15-Nov-22
# Change Log:
# 15-Nov-22: commented subnets 


variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-b"
}

variable "project-id" {
  default = ""
}


variable "main-vpc" {
  default = "ahsancorp-vpc-2"
}

/****
variable "subnet-02" {
  default = "singapore-1"
}


variable "subnet-02" {
  default = "germany-1"
}
*******/