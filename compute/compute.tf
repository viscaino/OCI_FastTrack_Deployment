# Terraform v0.12 is assumed
// Created by Bruno Viscaino

###################################################################
##
##      COMPUTE INSTANCE
##      This block deploy:
##          - Compute
##          - Volumes
##          - Volumes Attachment
##
##      PS: We are working to create a map for AD selection.
##      PS: Create a randomic AD distribution
##      PS: Create a possibility to create multiple volumes
##          dynamically.
##
###################################################################

#--INSTANCE-CREATION--------------------------------------------------------------------------------------------
data "oci_identity_compartments" "my_compute_comp" {
    depends_on      = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Compute"]
        regex   = true
    }
}

resource "oci_core_instance" "my_pub_instance" {
    for_each            = "${var.server_list}"
    depends_on          = ["oci_core_subnet.public"]
    availability_domain = "${each.value["ad"]}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
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

#--INSTANCE-Selection-----------------------------------------------------------------------------------------
data "oci_core_instances" "my_instances" {
    depends_on      = [
        "oci_core_instance.my_pub_instance",
        "oci_core_subnet.public"
        ]
    compartment_id  = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"

    filter {
        name    = "state"
        values  = ["RUNNING"]
    }
}

#--VOLUMES-CREATION--------------------------------------------------------------------------------------------
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

#--VOLUMES-Selection-----------------------------------------------------------------------------------------
data "oci_core_volumes" "my_data_vols" {
    depends_on      = ["oci_core_volume.create_volume"]
    compartment_id  = "${lookup(data.oci_identity_compartments.my_storage_comp.compartments[0], "id")}"

    filter {
        name    = "state"
        values  = ["AVAILABLE"]
    }
}

#--VOLUMES-Attachment---------------------------------------------------------------------------------------

resource "oci_core_volume_attachment" "attach_volume" {
    for_each        = "${var.server_list}"
    depends_on      = ["oci_core_volume.create_volume"]
    attachment_type = "iscsi"
    instance_id     = "${lookup(data.oci_core_instances.my_instances.instances[each.value["idxctrl"]], "id")}"
    volume_id       = "${lookup(data.oci_core_volumes.my_data_vols.volumes[each.value["idxctrl"]], "id")}"
}

data "oci_core_volume_attachments" "my_data_attach" {
    depends_on      = [
        "oci_core_instance.my_pub_instance",
        "oci_core_volume_attachment.attach_volume"
    ]
    compartment_id  = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
}

#--PROVISIONER-----------------------------------------------------------------------------------------------
#
#resource "null_resource" "remote-exec" {
#    depends_on = [
#        "oci_core_instance.my_pub_instance",
#        "oci_core_volume_attachment.attach_volume"
#    ] 
#
#    provisioner "remote-exec" {
#        connection {
#            agent   = false
#            timeout = "5min"
#            host    = "${data.oci_core_instances.my_instances.instances.public_ip}"
#            user    =  "opc"
#            private_key = "${file(var.ssh_private_key)}"
#        }
#        inline = ["touch /tmp/IMadeAFile.Right.Here"]           
#    }
#}
#
#--OUTPUTS---------------------------------------------------------------------------------------------------