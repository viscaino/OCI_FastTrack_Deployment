# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// Creating the compartments

resource "oci_identity_compartment" "CreateCompartment" {
    name = "Compartment01"
    description = "teste"
    compartment_id = "${var.compartment_id}"
    freeform_tags = "${oci_identity_tag.terraform_tag.name[0]}"
}