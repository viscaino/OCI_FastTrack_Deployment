# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_route_table" "private" {
    display_name    = "${var.env_prefix}${var.vcn_name}${var.priv_route_tab_name}"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
    
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}

output "RouteTable_Priv_Output" {
//    depends_on  = ["oci_core_route_table.private"]
    value       = "${oci_core_route_table.private.id}"
}