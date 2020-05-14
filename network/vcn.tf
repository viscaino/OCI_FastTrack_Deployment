# Terraform v0.12 is assumed
// Created by Bruno Viscaino

data "oci_identity_compartments" "net_comp_list" {
    compartment_id  = "${var.root_compartment}"
}

output "output_data_comp" {
    value = "${data.oci_identity_compartments.net_comp_list}"
}

/*
output "output_data_comp_lookup" {
    value = "${lookup(data.oci_identity_compartments.net_comp_list)}}"
}
*/
/*
resource "oci_core_vcn" "private_vcn" {
    compartment_id  = "${lookup(data.oci_identity_compartments.net_comp_list[0], "${var.env_prefix}Netcomp")}}"
    cidr_block      = "${var.priv_cidr}"
    dns_label       = "${var.priv_dns_label}"
}

resource "oci_core_vcn" "public_vcn"{
    cidr_block = "$(ar.cidr)"
    dns_lavbel = "publicvcn01"
    compartment_id ="$(var.compartment_id)"
    display_name = "publicvcn01"
}

output "vcn_id" {
    value = "${oci_core_vcn.publicvcn.id}"
}
*/