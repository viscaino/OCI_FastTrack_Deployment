# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

terraform {
  required_version = ">= 0.12"
}

module "iam_mod" {
  source = "./iam/"
}

/*
module "network_mod" {
  source = "./network/"
}

module "compute_mod" {
  source = "./compute/"
}

module "storage_mod" {
  source = "./storage/"
}
*/