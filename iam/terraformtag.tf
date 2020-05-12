# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

resource "oci_identity_tag_namespace" "terraform_ns" {
    compartment_id = "${var.tenancy_id}"
    description = "TAG Namespace to identify Terraform creation."
    name = "TerraformTAGNS"
}

resource "oci_identity_tag" "terraform_tag"{
    tag_namespace_id = "${oci_identity_tag_namespace.terraform_ns.id}"
    description = "TAG to identify Terraform creation."
    name = "TerraformTAG"
    is_cost_tracking = false
}

output "tag_namespaces" {
  value = "${oci_identity_tag_namespace.terraform_ns.id}"
}

output "tags" {
  value = "${oci_identity_tag.terraform_tag.id}"
}

output "resource_defined_tags_key" {
  value = "${oci_identity_tag_namespace.terraform_ns.name}.${oci_identity_tag.terraform_tag.name}"
}