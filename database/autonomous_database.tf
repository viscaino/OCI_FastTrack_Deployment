# Terraform v0.12 is assumed
// Created by Bruno Viscaino

resource "random_string" "adb_password_creation" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  min_special = 1
}

data "oci_identity_compartments" "my_database_comp" {
    depends_on      = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Database"]
        regex   = true
    }
}

data "oci_database_autonomous_db_versions" "get_version" {
  compartment_id    = "${lookup(data.oci_identity_compartments.my_database_comp.compartments[0], "id")}"
  db_workload       = "${var.adb_workload}"
}

resource "oci_database_autonomous_database" "create_adb" {
  depends_on      = ["oci_identity_compartment.child_compartment"]
  compartment_id  = "${lookup(data.oci_identity_compartments.my_database_comp.compartments[0], "id")}"
  display_name    = "${var.adb_name}"
  db_name         = "${var.adb_name}"
  admin_password  = "${random_string.adb_password_creation.result}"
  
  cpu_core_count            = "1"
  data_storage_size_in_tbs  = "1"
  
  db_version              = "${data.oci_database_autonomous_db_versions.get_version.autonomous_db_versions.0.version}"
  db_workload             = "${var.adb_workload}"
  is_auto_scaling_enabled = "${var.adb_autoscaling}"
  license_model           = "${var.adb_license_model}"
  whitelisted_ips         = ["0.0.0.0/24"]

  defined_tags  = "${
    map(
      "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
    )
  }"

}

data "oci_database_autonomous_database_wallet" "data_adb_wallet" {
  autonomous_database_id = "${oci_database_autonomous_database.create_adb.id}"
  password               = "${random_string.adb_password_creation.result}"
  base64_encode_content  = "true"
}

#output "adb_output" {
#    value = "${oci_database_autonomous_database.create_adb}"
#}
#
#output "data_adb_wallet_output" {
#    value   = "${data.oci_database_autonomous_database_wallet.data_adb_wallet}"
#}