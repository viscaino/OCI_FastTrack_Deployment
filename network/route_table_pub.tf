# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "public" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.pub_route_tab_name}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id          = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"

    route_rules {
        destination         = "0.0.0.0/0"
        network_entity_id   = "${oci_core_internet_gateway.create_igw.id}"
    }
}

output "RouteTable_Pub_output" {
    depends_on  = ["oci_core_route_table.public"]
    value       = "${oci_core_route_table.public.id}"
}