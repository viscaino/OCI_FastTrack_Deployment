# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino


// Child Compartment Map Variable:
//
variable "Child_Compartment_Map" {
    type = "map"
    default = {
        Nested_Net = " Network Compartment. Creted by Terraform"
        Nested_Comp = " Compute Compartment. Creted by Terraform"
        Nested_Stor = " Storage Compartment. Creted by Terraform"
    }
}

// Creating a Parent Compartment
//
resource "oci_identity_compartment" "parent_compartment" {
    compartment_id  = "${var.root_compartment_id}"
    depends_on      = ["oci_identity_tag.terraform_tag_key"]
    name            = "${var.prod_prefix}_Compartment"
    description     = "${var.prod_prefix}..Environment" 
	defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

// Create a Child Compartment
//
resource "oci_identity_compartment" "child_compartment" {
    for_each        = "${var.Child_Compartment_Map}"
    depends_on      = ["oci_identity_tag.terraform_tag_key"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"
    name            = "${var.prod_prefix}_${each.key}"
    description     = "${var.prod_prefix}${each.value}" 
	defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}