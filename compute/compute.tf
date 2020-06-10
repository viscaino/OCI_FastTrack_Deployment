// 2020, Terradorm file created by Bruno Viscaino

###################################################################
##
##      COMPUTE INSTANCE
##      This block deploy:
##          - Compute
##          - Volumes
##          - Volumes Attachment
##
##      PS: Create a randomic AD distribution
##      PS: Working on multiple volumes creation and attachment
##          dynamically.
##          
###################################################################

#--INSTANCE-CREATION------------------------------------------------------------------------------------
#
resource "oci_core_instance" "my_pub_instance" {
    for_each            = "${var.server_list}"
    depends_on          = [
        "oci_core_subnet.public",
        "oci_identity_tag.terraform_tag_key"
    ]
    availability_domain = "${each.value["ad"]}"
    compartment_id      = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
    display_name        = "${each.value["name"]}"
    shape               = "${each.value["shape"]}"
    
    source_details {
        source_type = "image"
        source_id   = "${each.value["image"]}"
    }

    create_vnic_details {
        subnet_id           = "${oci_core_subnet.public.id}"
        display_name        = "${each.value["name"]}_pubvnic"
        assign_public_ip    = "${each.value["pubip"]}"
    }
    
    metadata    = {
        ssh_authorized_keys = "${file(var.ssh_public_key)}"
    }

    defined_tags    =  "${
        map(
            "${oci_identity_tag_namespace.terraform_tag_ns.name}.${oci_identity_tag.terraform_tag_key.name}", "${var.terra_tag_value}"
        )
    }"

}
/*
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
*/