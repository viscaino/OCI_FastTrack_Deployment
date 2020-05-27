# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "public" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.pub_route_tab_name}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_network_comp.compartments[0], "id")}"
    vcn_id          = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"


#    route_rules {
#        destination         = "0.0.0.0/0"
#        network_entity_id   = "${oci_core_internet_gateway.create_igw.id}"
#    }
}

output "RouteTable_Pub_Output" {
    depends_on  = ["oci_core_route_table.public"]
    value       = "${oci_core_route_table.public.id}"
}