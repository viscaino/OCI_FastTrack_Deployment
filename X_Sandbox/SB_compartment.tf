# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_compartment" "create_compartment" {
    for_each        = "${var.CompartmentMap}"
    depends_on      = ["oci_identity_tag.terraform_tag_key"]
    compartment_id  = "${var.compartment_id}"
    name            = "${each.key}"
    description     = "${each.value}" 
	defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}