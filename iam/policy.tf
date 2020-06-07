// 2020, Terradorm file created by Bruno Viscaino

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
    name            = "${var.env_prefix}${each.key}"
    description     = "${each.key}"
    compartment_id  = "${var.root_compartment}"
    
    statements      = [
        "${each.value["statement_1"]}",
        "${each.value["statement_2"]}"
    ]

  defined_tags    =  "${
    map(
      "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
    )
  }"
}