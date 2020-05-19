# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "private" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.priv_route_tab_name}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id          = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
}

output "RouteTable_Priv_output" {
    depends_on  = ["oci_core_route_table.private"]
    value       = "${oci_core_route_table.private.id}"
}