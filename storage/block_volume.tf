// 2020, Terradorm file created by Bruno Viscaino

#--VOLUMES-CREATION-------------------------------------------------------------------------------------
#
resource "oci_core_volume" "create_volume" {
    for_each            = "${var.server_list}"
    depends_on          = [
        "oci_core_instance.my_pub_instance"
        ]
    availability_domain = "${each.value["ad"]}"
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Storage"], "id")}"
    display_name        = "${each.value["volname"]}"
    size_in_gbs         = "${each.value["volsize"]}"
}

#--VOLUMES-Attachment-----------------------------------------------------------------------------------
#
resource "oci_core_volume_attachment" "attach_volume" {
    for_each        = "${var.server_list}"
    depends_on      = ["oci_core_volume.create_volume"]
    attachment_type = "iscsi"
    instance_id     = "${lookup(oci_core_instance.my_pub_instance[each.key], "id")}"
    volume_id       = "${lookup(oci_core_volume.create_volume[each.key], "id")}"
}