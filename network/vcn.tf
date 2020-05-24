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

data "oci_identity_compartments" "my_data_comp" {
    depends_on  = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Network"]
        regex   = true
    }
}

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "create_vcn" {
    display_name    = "${var.env_prefix}${var.vcn_name}"
    cidr_block      = "${var.vcn_cidr}"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    depends_on      = ["data.oci_identity_compartments.my_data_comp"]
}

resource "oci_core_internet_gateway" "create_igw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "${var.env_prefix}${var.vcn_name}_igw"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
}

output "my_igw_id_output" {
    depends_on  = ["oci_core_internet_gateway.create_igw"]
    value       = "${oci_core_internet_gateway.create_igw.id}"
}

resource "oci_core_service_gateway" "create_svcgw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "${var.env_prefix}${var.vcn_name}_svcgw"
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
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
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"  
}

output "my_natgw_output" {
    depends_on  = ["oci_core_nat_gateway.create_natgw"]
    value       = "${oci_core_nat_gateway.create_natgw.id}"  
}

data "oci_core_vcns" "my_data_vcn" {
    depends_on  = ["oci_core_vcn.create_vcn"]
    compartment_id  = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
}

output "my_vcns_output" {
    depends_on  = ["oci_core_vcn.create_vcn"]
    value       = "${lookup(data.oci_core_vcns.my_data_vcn.virtual_networks[0], "id")}"
}