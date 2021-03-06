// 2020, Terradorm file created by Bruno Viscaino

resource "random_string" "adb_password_creation" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  min_special = 1
}

resource "oci_database_autonomous_database" "create_adb" {
  depends_on      = ["oci_identity_compartment.child_compartment"]
  compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Database"], "id")}"
  display_name    = "${var.env_prefix}${var.adb_name}"
  db_name         = "${var.env_prefix}${var.adb_name}"
  admin_password  = "${random_string.adb_password_creation.result}"
  
  cpu_core_count            = "1"
  data_storage_size_in_tbs  = "1"
  
  db_version              = "${var.adb_version}"
  db_workload             = "${var.adb_workload}"
  is_auto_scaling_enabled = "${var.adb_autoscaling}"
  license_model           = "${var.adb_license_model}"
  whitelisted_ips         = ["0.0.0.0/24"]

  defined_tags    =  "${
    map(
      "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
    )
  }"

}

output "ADB_ID" {
    value = "${oci_database_autonomous_database.create_adb.id}"
}

/*
data "oci_database_autonomous_database_wallet" "data_adb_wallet" {
  autonomous_database_id = "${oci_database_autonomous_database.create_adb.id}"
  password               = "${random_string.adb_password_creation.result}"
  base64_encode_content  = "true"

output "data_adb_wallet_output" {
    value   = "${data.oci_database_autonomous_database_wallet.data_adb_wallet}"
}
*/