# Terraform v0.12 is assumed
// Created by Bruno Viscaino

####!!IMPROVEMENT!!################################################
##
##      SUBNET IMPROVMENT REQUIRED
##      Create a dynamic SUBNET CIDR definition based on VCN CIDR
##
###################################################################

resource "oci_core_subnet" "private" {  
    depends_on      = [
        "oci_core_vcn.create_vcn",
        "oci_core_route_table.private"
        ]
    display_name        = "${var.env_prefix}${var.vcn_name}${var.private_subnet_name}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    cidr_block          = "${var.private_subnet_cidr}"
    route_table_id      = "${oci_core_route_table.private.id}"
    security_list_ids   = ["${oci_core_security_list.seclist_private.id}"]
    prohibit_public_ip_on_vnic = true
}

output "priv_subnet_output" {
    depends_on  = ["oci_core_subnet.private"]
    value       = "${oci_core_subnet.private.id}"
}