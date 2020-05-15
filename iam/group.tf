# Terraform v0.12 is assumed
// Created by Bruno Viscaino

// Creating Group of Admin Per Environment Prefix
//
resource "oci_identity_group" "groups" {
    for_each        = "${var.group_map}"
    compartment_id  = "${var.tenancy}"
    name            = "${var.env_prefix}${each.key}_Group"
    description     = "${each.value}"
	defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

data "oci_identity_groups" "my_data_groups" {
    compartment_id  = "${var.tenancy}"
    
    filter {
        name    = "name"
        values  = ["key*"]
        regex   = true
    }
}

output "my_data_groups_output" {
    value = "${data.oci_identity_groups.my_data_groups.groups}"
}