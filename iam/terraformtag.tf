# Terraform v0.12 is assumed
// Created by Bruno Viscaino

// TAG Namespace Creation.
//
resource "oci_identity_tag_namespace" "terraform_tag_ns" {
    compartment_id  = "${var.tenancy_ocid}"
    description     = "TAG Namespace to identify Terraform creation."
    name            = "${var.terra_tag_ns}"
}

// TAG Key Creation.
//
resource "oci_identity_tag" "terraform_tag_key" {
    tag_namespace_id  = "${oci_identity_tag_namespace.terraform_tag_ns.id}"
    description       = "TAG Key to identify Terraform creation."
    name              = "${var.terra_tag_key}"
    is_cost_tracking  = true

    validator {
      validator_type  = "ENUM"
      values          = ["${var.terra_tag_value}"] //TAG Key Values
    }
}