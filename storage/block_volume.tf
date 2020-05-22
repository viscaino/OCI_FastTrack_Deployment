# Terraform v0.12 is assumed
// Created by Bruno Viscaino

data "oci_identity_compartments" "my_storage_comp" {
    depends_on      = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Storage"]
        regex   = true
    }
}

resource "oci_core_volume" "create_volume" {
    for_each            = "${var.server_list}"
    depends_on          = [
        "oci_core_instance.my_pub_instance",
        "data.oci_identity_compartments.my_storage_comp"
        ]
    availability_domain = "${each.value["ad"]}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_storage_comp.compartments[0], "id")}"
    display_name        = "${each.value["volname"]}"
    size_in_gbs         = "${each.value["volsize"]}"
}

data "oci_core_instances" "data_instances" {
    compartment_id  = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
}

/* WORKING IN PROGRESS
resource "oci_core_volume_attachment" "attach_volume" {
    depends_on      = ["oci_core_volume.create_volume"]
    attachment_type = "iscsi"
    instance_id     = ""
    volume_id       = ""
    device          = ""
}
*/

output "my_storage_comp_output" {
    depends_on  = ["oci_core_instances.data_instances"]
    value       = "${data.oci_identity_compartments.my_storage_comp.compartments}"
}

output "data_instances_output" {
    depends_on  = ["oci_core_instances.data_instances"]
    value       = "${data.oci_core_instances.data_instances.instances}"
}