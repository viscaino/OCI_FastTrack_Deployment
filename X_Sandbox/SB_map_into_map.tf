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

variable "testevar" {
    default = "na"
}
variable "my_map" {
    type = "map"
    default = {
        key1 = { na = "nameA1", da = "descA1"}
        key2 = { na = "nameA2", da = "descA2"}
    }
}

resource "oci_identity_group" "my_groups" {
    for_each        = "${var.my_map}"
    compartment_id  = "${var.tenancy}"
    name            = "${each.key}"
    description     = "${each.value[var.testevar]}"
}

data "oci_identity_groups" "my_data_groups_sb" {
    compartment_id  = "${var.tenancy}"
    
    filter {
        name    = "name"
        values  = ["key*"]
        regex   = true
    }
}

//output "output_data_groups" {
//    value   = "${data.oci_identity_groups.my_data_groups_sb.groups}"
//}

output "output_data_groups_lookup" {
    value   = "${lookup(data.oci_identity_groups.my_data_groups_sb.groups[0], "id")}"
}

