# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino
/*
resource "oci_core_vcn" "publicvcn"{
    cidr_block = "$(ar.cidr)"
    dns_lavbel = "publicvcn01"
    compartment_id ="$(var.compartment_id)"
    display_name = "publicvcn01"
}

output "vcn_id" {
    value = "${oci_core_vcn.publicvcn.id}"
}
*/