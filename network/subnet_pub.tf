# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_subnet" "public" {    
    depends_on      = [
        "oci_core_vcn.create_vcn",
        "oci_core_route_table.public"
        ]
    display_name        = "${var.env_prefix}${var.vcn_name}${var.public_subnet_name}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    cidr_block          = "${var.public_subnet_cidr}"
    route_table_id      = "${oci_core_route_table.public.id}"
    security_list_ids   = ["${oci_core_security_list.seclist_public.id}"]
}

output "pub_subnet_output" {
    depends_on  = ["oci_core_subnet.public"]
    value       = "${oci_core_subnet.public.id}"
}