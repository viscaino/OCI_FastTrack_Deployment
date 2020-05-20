# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// OCI Region Definition:
//
variable "region" {
    default = "us-ashburn-1"
}

// OCI Customer Tenancy OCID:
//
variable "tenancy_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaa7ojo7t7hedpsnqglouvvvxuakdxtkhb2t542pf5dch4ly2lprcla"
}

// Root Compartment:
//
variable "root_compartment" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

// Environment in use:
//
variable "env_prefix" {
    default = "TESTE"
}

// Nested Compartment Map:
//
variable "childmap" {
    type = "map"
    default = {
        _XNetwork_Comp   = "Network Compartment"
        _XCompute_Comp   = "Compute Compartment"
        _XStorage_Comp   = "Storage Compartment"
    }
}

// TAG Namespace variable:
//
variable "terra_tag_ns" {
    default = "tag_ns_teste1"
}

// TAG Key variable:
//
variable "terra_tag_key" {
    default = "tag_key_teste1"
}

// TAG value variable:
//
variable "terra_tag_value" {
    default = "tag_value_teste1"
}

// Map of Group in Environment Prefix:
//
variable "group_map" {
    type = "map"
    default = {
        Network = "Network Group Admin"
        Compute = "Compute Group Admin"
        Storage = "Storage Group Admin"
        Admin   = "This Group is a Environment Admin"
    }
}


// VCN Name:
//
variable "vcn_name" {
    default = "vcn"
}

// VCN CIDR:
//
variable "vcn_cidr" {
    default = "10.0.0.0/16"
}

// Private Subnet Name:
//
variable "private_subnet_name" {
    default = "Priv_subnet"
}

// Private Subnet CIDR:
//
variable "private_subnet_cidr" {
    default = "10.0.1.0/24"
}

// Private Route Table Name:
//
variable "priv_route_tab_name" {
    default = "Priv_RT"
}

// Private Security List Name:
//
variable "private_seclist_name" {
    default = "Priv_SecList"
}

// Public Subnet Name:
//
variable "public_subnet_name" {
    default = "Pub_subnet"
}

// Public Subnet CIDR:
//
variable "public_subnet_cidr" {
    default = "10.0.2.0/24"
}

// Public Route Table Name:
//
variable "pub_route_tab_name" {
    default = "Pub_RT"
}

// Public Security List Name:
//
variable "public_seclist_name" {
    default = "Pub_SecList"
}

// SSH public Key
// PS.: Working to extract from file
//
variable "ssh_public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1EDq34mbfQkE4P5Pq2hFPAirRBqD3o/eAyh55FxsYobnEgjFk6fJS5UKd4jOBJhm12kjJEgotblwePCqbTKIFudXVl0VwW2QgswgSqSnc5InEyHzsSfztJ3yaaGocSVMtNUtMIFcw6ICsghkYB2swsUMY8qj0vV0qLsHEZ8Xr7Ti6ae8iDGfmJ2zf/lG7oUSlYO52pqFrT9T9ThSRpJAxM2d2PXy/cVhBn8QQoaIuUdjbZVkH94cGwlxhqwIJYO6aNDjKivrDNSb1VQY/PcLhPUFXdXxwpOBL2tUC1vkjujcdHtOgCb8mwS+Z2W4zjZ3d7oBgE4VgRNnD3vIMymSPw=="
}