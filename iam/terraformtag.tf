// Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// TAG Namespace Creation.
resource "oci_identity_tag_namespace" "terraform_tag_ns" {
    compartment_id  = "${var.tenancy_id}"
    description     = "TAG Namespace to identify Terraform creation."
    name            = "${var.terra_tag_ns}"
}

// TAG Key Creation.
resource "oci_identity_tag" "terraform_tag_key" {
    tag_namespace_id  = "${oci_identity_tag_namespace.terraform_tag_ns.id}"
    description       = "TAG Key to identify Terraform creation."
    name              = "${var.terra_tag_key}"
    is_cost_tracking  = false

    validator {
      validator_type  = "ENUM"
      values          = ["${var.terra_tag_value}", "other_value"] //TAG Key Values
    }
}

// Output to validate execution
output "tag_namespaces" {
  value = ["${oci_identity_tag_namespace.terraform_tag_ns.id}"]
}

output "tags" {
  value = ["${oci_identity_tag.terraform_tag_key.id}"]
}