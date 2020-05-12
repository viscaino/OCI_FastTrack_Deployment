# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

variable "region" {}

variable "compartment_id" {}

variable "CompartmentList" {
    default = ["ProdNetCompartment", "QANetCompartment", "DevNetCompartment"]
    }