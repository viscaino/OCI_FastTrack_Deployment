# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_compartment" "CreateCompartment" {
    dynamic "comp" {
        for_each = "${var.mapcompartment}"
        content {
            key = "comp.key"
            value = "comp.value"
        }
    }
    name = "comp.key"
    description = "comp.value"
    defined_tags = "${oci_identity_tag.terraform_tag.id}"
    compartment_id = "${var.compartment_id}"
}

output "compartments" {
    value = "${oci_identity_compartment.CreateCompartment.id}"
}