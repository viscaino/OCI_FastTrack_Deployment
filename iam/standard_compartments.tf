# Terraform v0.12 is assumed
// Created by Bruno Viscaino
###################################################################
##
##      CCOMPARTMENT BLOCK
##      This block deploy the compartment sctucture based on
##      environment prefix and map compartment variables:
##      
##      Sample of deployment:
##      
##      EnvPrefix_Compartment
##      |
##      |_EnvPrefixNetworkCompartment
##      |_EnvPrefixStorageCompartment
##      |_EnvPrefixComputeCompartment
##
##      Repeat it for QA and Dev changing the Environment Prefix
##      variable.
##
###################################################################

// Create a Parent Compartment:
//
resource "oci_identity_compartment" "parent_compartment" {
    compartment_id  = "${var.root_compartment}"
#    depends_on      = ["oci_identity_tag.terraform_tag_key"]
    name            = "${var.env_prefix}_Compartment"
    description     = "${var.env_prefix}_Environment"
}

// Create a Child Compartments:
// PS: This block use a for_each function based on map variable
//
resource "oci_identity_compartment" "child_compartment" {
    for_each        = "${var.childmap}"
    depends_on      = ["oci_identity_compartment.parent_compartment"]
    name            = "${var.env_prefix}${each.key}"
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"
    description     = "${var.env_prefix} ${each.value}"
}