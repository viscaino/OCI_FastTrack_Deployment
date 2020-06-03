# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "private" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.priv_route_tab_name}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_network_comp.compartments[0], "id")}"
    vcn_id          = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

output "RouteTable_Priv_Output" {
    depends_on  = ["oci_core_route_table.private"]
    value       = "${oci_core_route_table.private.id}"
}