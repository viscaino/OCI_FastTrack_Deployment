// 2020, Terradorm file created by Bruno Viscaino

resource "oci_core_route_table" "public" {
    depends_on      = [
        "oci_core_internet_gateway.create_igw"
    ]
    display_name    = "${var.env_prefix}${var.vcn_name}${var.pub_route_tab_name}"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
    
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"

    route_rules {
        destination         = "0.0.0.0/0"
        network_entity_id   = "${oci_core_internet_gateway.create_igw.id}"
    }
}

output "RouteTable_Pub_Output" {
    value       = "${oci_core_route_table.public.id}"
}