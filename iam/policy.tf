# Terraform v0.12 is assumed
// Created by Bruno Viscaino
###-!!WARNING!!-####################################################
##
##      !!WARNING!! POLICY BLOCK
##      The policies included in this block is a PRE-DEFINED  
##      POLICY STATEMENTS. We are developing a dynamic policy
##      statements improvements.
##      
###################################################################

resource "oci_identity_policy" "create_policy" {
    for_each        = "${var.PolicyMap}"
    depends_on      = [
        "oci_identity_compartment.child_compartment",
        "oci_identity_group.groups"
        ]
    name            = "${each.key}"
    description     = "${each.key}"
    compartment_id  = "${var.root_compartment}"
    statements      = [
        "${each.value["statement_1"]}",
        "${each.value["statement_2"]}"
    ]
}