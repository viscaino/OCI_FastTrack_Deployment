# Terraform v0.12 is assumed
// Created by Bruno Viscaino

data "oci_identity_compartments" "my_data_comp" {
    depends_on  = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["\\w*Network"]
        regex   = true
    }
}

output "my_data_comp_output" {
    depends_on  = ["data.oci_identity_compartments.my_data_comp"]
    value       = "${data.oci_identity_compartments.my_data_comp.compartments}"
}

output "my_data_comp_output_id" {
    depends_on  = ["data.oci_identity_compartments.my_data_comp"]
    value   = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
}

resource "oci_core_vcn" "create_vcn" {
    display_name    = "${var.env_prefix}${var.vcn_name}"
    cidr_block      = "${var.vcn_cidr}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    depends_on      = ["data.oci_identity_compartments.my_data_comp"]
}