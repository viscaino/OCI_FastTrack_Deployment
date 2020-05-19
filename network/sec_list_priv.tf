# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_security_list" "seclist_private" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    compartment_id      = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    display_name        = "${var.env_prefix}${var.vcn_name}${var.private_seclist_name}"
}