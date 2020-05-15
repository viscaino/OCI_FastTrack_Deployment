# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// OCI Region Definition:
//
variable "region" {
    default = "us-ashburn-1"
}

// OCI Customer Tenancy id:
//
variable "tenancy" {
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
    default = "Prod"
}

// Nested Compartment Map:
//
variable "childmap" {
    type = "map"
    default = {
        NestedNet       = "Network Compartment"
        NestedCompute   = "Compute Compartment"
        NestedStorage   = "Storage Compartment"
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