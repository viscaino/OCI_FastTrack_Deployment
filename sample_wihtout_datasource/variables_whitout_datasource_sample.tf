# Terraform v0.12 is assumed
// Created by Bruno Viscaino

provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}

variable "region" {
    default = "us-ashburn-1"
}

variable "root_compartment" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

variable "env_prefix" {
    default = "Test"
}

variable "childmap" {
    type = "map"
    default = {
        Network  = "Network Compartment",
        Compute  = "Compute Compartment",
        Storage  = "Storage Compartment",
        Database = "Database Compartment"
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

// Security List Rules
variable "pub_seclist_ingress_rules" {
    type = "map"
    default = {
        role001 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "22",
            max         = "22"
        }
        role002 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "80",
            max         = "80"
        }
    }
}

variable "pub_seclist_egress_rules" {
    type = "map"
    default = {
        role001 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "22",
            max         = "22"
        }
        role002 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "80",
            max         = "80"
        }
    }
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