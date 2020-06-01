# Terraform v0.12 is assumed
// Created by Bruno Viscaino

###################################################################
##
##      DEPRECATED BY COMPUTE TF FILE
##          Currently this block was included into compute
##          tf file.
##
###################################################################
/*
data "oci_identity_compartments" "my_storage_comp" {
    depends_on      = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Storage"]
        regex   = true
    }
}

data "oci_core_instances" "my_instances_for_bs" {
    compartment_id      = "${lookup(data.oci_identity_compartments.my_storage_comp.compartments[0], "id")}"
}

output "my_instances_for_bs_output" {
    value   = "${lookup(data.oci_core_instances.my_instances_for_bs)}"
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

//---------------------//
// WORKING IN PROGRESS //
//---------------------//
resource "oci_core_volume_attachment" "attach_volume" {
    for_each        = "${var.server_list}"
    depends_on      = ["oci_core_volume.create_volume"]
    attachment_type = "iscsi"
    instance_id     = "${data.oci_core_instances.data_instances.instances[]}"
    volume_id       = "${oci_core_volume.test_block_volume.*.id[valus(${each.valu["int_crtl"]})]}"
    device          = ""
}
*/