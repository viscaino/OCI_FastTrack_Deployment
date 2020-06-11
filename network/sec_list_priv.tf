// 2020, Terradorm file created by Bruno Viscaino

resource "oci_core_security_list" "seclist_private" {
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    display_name        = "${var.env_prefix}${var.vcn_name}${var.private_seclist_name}"
    
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

output "Private_SecurityList_ID" {
    value       = "${oci_core_security_list.seclist_private.id}"
}