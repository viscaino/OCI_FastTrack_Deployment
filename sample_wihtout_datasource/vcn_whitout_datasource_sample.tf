# Terraform v0.12 is assumed
// Created by Bruno Viscaino

###################################################################
##
##      VCN
##      This block deploy the a default VCN including:
##
##       - Virtual Cloud Network
##       - Internet Gateway
##       - Service Gateway
##       - NAT Gateway
##
##      PS: We are working to improve data lookup
##
###################################################################

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "create_vcn" {
    depends_on      = [
        "oci_identity_compartment.child_compartment",
    ]
    display_name    = "${var.env_prefix}${var.vcn_name}"
    cidr_block      = "${var.vcn_cidr}"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
}

output "VCN_Outputs" {
    value  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
}

resource "oci_core_internet_gateway" "create_igw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "${var.env_prefix}${var.vcn_name}_igw"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
}

output "my_igw_id_output" {
    depends_on  = ["oci_core_internet_gateway.create_igw"]
    value       = "${oci_core_internet_gateway.create_igw.id}"
}

resource "oci_core_service_gateway" "create_svcgw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "${var.env_prefix}${var.vcn_name}_svcgw"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
    services {
    service_id = "${lookup(data.oci_core_services.test_services.services[0], "id")}"
  }
}

output "my_svcgw_output" {
    depends_on  = ["oci_core_service_gateway.create_svcgw"]
    value       = "${oci_core_service_gateway.create_svcgw.id}"
}

resource "oci_core_nat_gateway" "create_natgw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "${var.env_prefix}${var.vcn_name}_natgw"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"  
}

output "my_natgw_output" {
    depends_on  = ["oci_core_nat_gateway.create_natgw"]
    value       = "${oci_core_nat_gateway.create_natgw.id}"  
}