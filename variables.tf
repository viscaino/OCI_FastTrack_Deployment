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

// List of Compartments Description:
variable "CompartmentMap" {
    type = "map"
    default = {
        ProdNetComp = "Production Network Compartment. Creted by Terraform"
        QANetComp = "QA Network Compartment. Creted by Terraform"
        DevNetComp = "Development Network Compartment. Creted by Terraform"
        ProdComputeComp = "Production Compute Compartment. Creted by Terraform"
        QAComputeComp = "QA Compute Compartment. Creted by Terraform"
        DevComputeComp = "Development Compute Compartment. Creted by Terraform"
        ProdStorageComp = "Production Storage Compartment. Creted by Terraform"
        QAStorageComp = "QA Storage Compartment. Creted by Terraform"
        DevStorageComp = "Development Storage Compartment. Creted by Terraform"
    }
}