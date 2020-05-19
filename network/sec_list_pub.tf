# Terraform v0.12 is assumed
// Created by Bruno Viscaino

###-!!WARNING!!-####################################################
##
##      SECURITY LIST FOR PUBLIC SUBNET
##      Consider change the security rules to improve the 
##      security baseline.
##      
###################################################################

resource "oci_core_security_list" "seclist_public" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    compartment_id      = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id              = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
    display_name        = "${var.env_prefix}${var.vcn_name}${var.public_seclist_name}"

    ingress_security_rules {
        protocol    = "6"
        source      = "0.0.0.0/0"

        tcp_options {
            min     = "22"
            max     = "22"
        }
    }

    egress_security_rules {
        protocol    = "6"
        destination = "0.0.0.0/0"

        tcp_options {
            min     = "22"
            max     = "22"
        }        
    }
}