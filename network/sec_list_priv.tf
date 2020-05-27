# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_core_security_list" "seclist_private" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    compartment_id      = "${lookup(data.oci_identity_compartments.my_network_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    display_name        = "${var.env_prefix}${var.vcn_name}${var.private_seclist_name}"
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"


#    ingress_security_rules {
#        protocol    = "6"
#        source      = "0.0.0.0/0"
#
#        tcp_options {
#            min     = "22"
#            max     = "22"
#        }
#    }
#
#    egress_security_rules {
#        protocol    = "6"
#        destination = "0.0.0.0/0"
#
#        tcp_options {
#            min     = "22"
#            max     = "22"
#        }
#    }
}

output "SecurityList_Priv_Output" {
    depends_on  = ["oci_core_security_list.seclist_private"]
    value       = "${oci_core_security_list.seclist_private.id}"
}