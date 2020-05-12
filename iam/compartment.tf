# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_compartment" "CreateCompartment" {
    for_each = "list.${var.CompartmentList}"
    name = "list.${var.CompartmentList}"
    description = "Teste"
    compartment_id = "$(var.compartment_id)"
}