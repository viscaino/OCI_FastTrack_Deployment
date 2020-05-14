# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "oci_identity_group" "groups" {
    for_each    = "${var.groupmap}"
    name        = "${var.env_prefix}${each.key}"
    description = "${each.value}"
	defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"
}