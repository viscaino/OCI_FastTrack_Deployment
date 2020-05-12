# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_compartment" "CreateCompartment" {
    name = "${var.dynvar}[name]"
    description = "${var.dynvar}[description]"
    defined_tags = "${oci_identity_tag.terraform_tag.id}"
    compartment_id = "${var.compartment_id}"
}

output "compartments" {
    value = "${oci_identity_compartment.CreateCompartment.id}"
}