# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_tag_namespace" "terraform_ns" {
    compartment_id  = "${var.tenancy_id}"
    description     = "TAG Namespace to identify Terraform creation."
    name            = "${var.terra_ns}"
}

resource "oci_identity_tag" "terraform_tag" {
    tag_namespace_id  = "${oci_identity_tag_namespace.terraform_ns.id}"
    description       = "TAG Key to identify Terraform creation."
    name              = "${var.terra_tag}"
    is_cost_tracking  = false

    validator {
      validator_type  = "ENUM"
      values          = ["${var.terra_def_tag}", "other_value"]
    }
}

output "tag_namespaces" {
  value = ["${oci_identity_tag_namespace.terraform_ns.id}"]
}

output "tags" {
  value = ["${oci_identity_tag.terraform_tag.id}"]
}