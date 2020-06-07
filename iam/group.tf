// 2020, Terradorm file created by Bruno Viscaino

###################################################################
##
##      Group
##      This block deploy groups based on the map variable. The 
##      taxonomy use Env + Scope + _Group, example:
##        DevNetwork_Group
##
###################################################################

resource "oci_identity_group" "groups" {
    for_each        = "${var.group_map}"
    compartment_id  = "${var.tenancy_ocid}"
    name            = "${var.env_prefix}${each.key}_Group"
    description     = "${each.value}"
    
  defined_tags    =  "${
    map(
      "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
    )
  }"
  
}