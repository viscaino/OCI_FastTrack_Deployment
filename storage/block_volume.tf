# Terraform v0.12 is assumed
// Created by Bruno Viscaino

data "oci_core_instances" "data_instances" {
    compartment_id  = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
}

output "data_instance_ouput_ocid" {
    depends_on  = ["oci_core_instances.data_instances"]
    value       = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
}

output "data_instances_output" {
    depends_on  = ["oci_core_instances.data_instances"]
    value       = "${data.oci_core_instances.data_instances.instances}"
}

resource "oci_core_volume" "create_volume" {
    for_each            = "${var.server_list}"
    depends_on          = ["oci_core_instance.my_pub_instance"]
    availability_domain = "${each.value["ad"]}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
    display_name        = "${each.value["volname"]}"
    size_in_gbs         = "${each.value["volsize"]}"
}