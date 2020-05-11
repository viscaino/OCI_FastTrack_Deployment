variable "compartment_id" {}

resource "oci_core_vcn" {
    compartment_id = var.compartment_id
}