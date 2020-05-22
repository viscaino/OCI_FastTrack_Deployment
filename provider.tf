# Terraform v0.12 is assumed
// Created by Bruno Viscaino

provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}