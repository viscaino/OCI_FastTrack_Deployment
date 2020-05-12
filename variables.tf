# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

variable "region" {
    default = "us-ashburn-1"
}

variable "compartment_id" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

variable "tenancy_id" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

variable "mapcompartment" {
    default = {
        ProdNetCompartment = "Production Network Compartment. Creted by Terraform"
        QANetCompartment = "QA Network Compartment. Creted by Terraform"
        DevNetCompartment = "Development Network Compartment. Creted by Terraform"
    }
}