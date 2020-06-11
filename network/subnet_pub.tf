// 2020, Terradorm file created by Bruno Viscaino

####!!IMPROVEMENT!!################################################
##
##      SUBNET IMPROVMENT REQUIRED
##      Create a dynamic SUBNET CIDR definition based on VCN CIDR
##
###################################################################

resource "oci_core_subnet" "public" {    
    depends_on      = [
        "oci_core_vcn.create_vcn",
        "oci_core_route_table.public"
        ]
    display_name        = "${var.env_prefix}${var.vcn_name}${var.public_subnet_name}"
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    cidr_block          = "${var.public_subnet_cidr}"
    route_table_id      = "${oci_core_route_table.public.id}"
    security_list_ids   = ["${oci_core_security_list.seclist_public.id}"]
    prohibit_public_ip_on_vnic = false

    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

output "Public_Subnet_ID" {
    value       = "${oci_core_subnet.public.id}"
}