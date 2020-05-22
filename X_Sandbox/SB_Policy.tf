# Terraform v0.12 is assumed
// Created by Bruno Viscaino

//  Provider
//
provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

// OCI Region Definition:
//
variable "region" {
    default = "us-ashburn-1"
}

// OCI Customer Tenancy id:
//
variable "tenancy" {
    default = "ocid1.tenancy.oc1..aaaaaaaa7ojo7t7hedpsnqglouvvvxuakdxtkhb2t542pf5dch4ly2lprcla"
}

// Environment in use:
//
variable "env_prefix" {
    default = "Prod"
}

#################################################################################################
#################################################################################################

// Map of Group in Environment Prefix:
//
variable "group_map" {
    type = "map"
    default = {
        Network = "Network Group Admin"
        Compute = "Compute Group Admin"
        Storage = "Storage Group Admin"
        Admin   = "This Group is a Environment Admin"
    }
}

// Creating Group of Admin Per Environment Prefix
//
resource "oci_identity_group" "groups" {
    for_each        = "${var.group_map}"
    compartment_id  = "${var.tenancy}"
    name            = "${var.env_prefix}${each.key}_Group"
    description     = "${each.value}"
}

// Map of Policy in Environment Prefix:
//
variable "policy_map" {
    type = "map"
    default = {
        Network   = "Network Group Admin"
        Compute    = "Compute Group Admin"
        Storage    = "Storage Group Admin"
        Admin      = "This Group is a Environment Admin"
    }
}

resource "oci_identity_policy" "create_policy" {
    for_each        = "${var.groupmap}"
    name            = "${var.env_prefix}${each.key}_Policy"
    description     = "${each.key} Policies"
    compartment_id  = "${var.tenancy}"
    statements      = [
        "Allow group ProdNetworkAdmin to manage network-family in ${var.env_prefix}_Compartment:ProdNetworkCompartment",
        ""
    ]

}