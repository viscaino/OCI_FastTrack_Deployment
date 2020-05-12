# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// OCI Region Definition:
variable "region" {
    default = "us-ashburn-1"
}

// Customer Tenancy Definition:
variable "tenancy_id" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

// Customer Compartment Definition:
// PS: For the first execution use the Root Compartment.
variable "compartment_id" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

// TAG Namespace variable:
variable "terra_tag_ns" {
    default = "tag_ns_teste1"
}

// TAG Key variable:
variable "terra_tag_key" {
    default = "tag_key_teste1"
}

// TAG value variable:
variable "terra_tag_value" {
    default = "tag_value_teste1"
}

// List of Compartments:
variable "mapcompartment" {
    default = {
        ProdNetCompartment = "Production Network Compartment. Creted by Terraform"
        QANetCompartment = "QA Network Compartment. Creted by Terraform"
        DevNetCompartment = "Development Network Compartment. Creted by Terraform"
    }
}