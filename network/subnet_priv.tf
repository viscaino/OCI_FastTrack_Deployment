// 2020, Terradorm file created by Bruno Viscaino

####!!IMPROVEMENT!!################################################
##
##      SUBNET IMPROVMENT REQUIRED
##      Create a dynamic SUBNET CIDR definition based on VCN CIDR
##
###################################################################

resource "oci_core_subnet" "private" {  
    display_name        = "${var.env_prefix}${var.vcn_name}${var.private_subnet_name}"
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    cidr_block          = "${var.private_subnet_cidr}"
    route_table_id      = "${oci_core_route_table.private.id}"
    security_list_ids   = ["${oci_core_security_list.seclist_private.id}"]
    prohibit_public_ip_on_vnic = true

    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

output "Subnet_Priv_Output" {
    value       = "${oci_core_subnet.private.id}"
}