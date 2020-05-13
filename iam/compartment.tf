# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// Creating the compartments
/* THIS BLOCK WORKS
resource "oci_identity_compartment" "create_compartment" {
    count           = "${length(var.CompartmentName)}"
    compartment_id  = "${var.compartment_id}"
    name            = "${var.CompartmentName[count.index]}"
    description     = "teste"
}
*/

resource "oci_identity_compartment" "create_compartment" {
    for_each        = "${var.CompartmentMap}"
    compartment_id  = "${var.compartment_id}"
    name            = "${each.key}"
    description     = "${each.value}" 
}