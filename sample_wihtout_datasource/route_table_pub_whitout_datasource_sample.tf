# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "public" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.pub_route_tab_name}"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"

    route_rules {
        destination         = "0.0.0.0/0"
        network_entity_id   = "${oci_core_internet_gateway.create_igw.id}"
    }
}

output "RouteTable_Pub_Output" {
    depends_on  = ["oci_core_route_table.public"]
    value       = "${oci_core_route_table.public.id}"
}