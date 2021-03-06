// 2020, Terradorm file created by Bruno Viscaino

###-!!WARNING!!-####################################################
##
##      SECURITY LIST FOR PUBLIC SUBNET
##      Consider change the security rules to improve the 
##      security baseline.
##      
###################################################################

resource "oci_core_security_list" "seclist_public" {
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    display_name        = "${var.env_prefix}${var.vcn_name}${var.public_seclist_name}"
    
    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"

    dynamic "ingress_security_rules" {
        for_each = "${var.pub_seclist_ingress_rules}"
        content {

            protocol    = "${ingress_security_rules.value["protocol"]}"
            source      = "${ingress_security_rules.value["source"]}"

            tcp_options {
                min     = "${ingress_security_rules.value["min"]}"
                max     = "${ingress_security_rules.value["max"]}"
            }
        }
    }

    dynamic "egress_security_rules" {
        for_each = "${var.pub_seclist_egress_rules}"
        content {

            protocol    = "${egress_security_rules.value["protocol"]}"
            destination = "${egress_security_rules.value["destination"]}"

            tcp_options {
                min     = "${egress_security_rules.value["min"]}"
                max     = "${egress_security_rules.value["max"]}"
            }
        }
    }
}

output "Public_SecurityList_ID" {
    value       = "${oci_core_security_list.seclist_public.id}"
}