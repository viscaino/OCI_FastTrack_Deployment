# Terraform v0.12 is assumed
// Created by Bruno Viscaino

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
    compartment_id      = "${lookup(data.oci_identity_compartments.my_network_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
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

output "Subnet_Pub_Output" {
    depends_on  = ["oci_core_subnet.public"]
    value       = "${oci_core_subnet.public.id}"
}