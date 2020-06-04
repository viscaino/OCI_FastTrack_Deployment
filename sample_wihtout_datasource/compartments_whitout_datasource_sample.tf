# Terraform v0.12 is assumed
// Created by Bruno Viscaino

// Create a Parent Compartment:
//
resource "oci_identity_compartment" "parent_compartment" {
    compartment_id  = "${var.root_compartment}"
    name            = "${var.env_prefix}_Compartment"
    description     = "${var.env_prefix}_Environment"
}

// Create a Child Compartments:
// PS: This block use a for_each function based on map variable
//
resource "oci_identity_compartment" "child_compartment" {
    for_each        = "${var.childmap}"
    depends_on      = ["oci_identity_compartment.parent_compartment"]
    name            = "${var.env_prefix}${each.key}"
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"
    description     = "${var.env_prefix} ${each.value}"
    enable_delete   = true
}

output "res_my_child_compartments_output_1" {
    value = "${oci_identity_compartment.child_compartment["Network"]}"
}

output "res_my_child_compartments_output_2" {
    value = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
}