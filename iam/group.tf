# Terraform v0.12 is assumed
// Created by Bruno Viscaino

// Creating Group of Admin Per Environment Prefix
//
resource "oci_identity_group" "groups" {
    for_each        = "${var.group_map}"
    compartment_id  = "${var.tenancy_ocid}"
    name            = "${var.env_prefix}${each.key}_Group"
    description     = "${each.value}"
}

data "oci_identity_groups" "my_data_groups" {
    compartment_id  = "${var.tenancy_ocid}"
    
    filter {
        name    = "name"
        values  = ["key\\w*"]
        regex   = true
    }
}

output "my_data_groups_output" {
    value = "${data.oci_identity_groups.my_data_groups.groups}"
}