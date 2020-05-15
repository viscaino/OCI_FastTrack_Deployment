# Terraform v0.12 is assumed
// Created by Bruno Viscaino

variable "PolicyMap" {
    type = "map"
    NetworkPolicy = "Allow group ProdNetworkAdmin to manage network-family in ${var.env_prefix}_Compartment:ProdNetworkCompartment"
}

resource "oci_identity_policy" "create_policy" {
    name            = "Network"
    description     = "Network Policies"
    compartment_id  = "${var.tenancy}"
    statements      = [
        ""
    ]

}