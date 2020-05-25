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
        ssh_authorized_keys = "${var.ssh_public_key}"
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

#--INSTANCE-Selection-----------------------------------------------------------------------------------------
data "oci_core_instances" "data_inst" {
    depends_on      = ["oci_core_instance.my_pub_instance"]
    compartment_id  = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"

    filter {
        name    = "state"
        values  = ["RUNNING"]
    }
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
    instance_id     = "${lookup(data.oci_core_instances.data_inst.instances[each.value["idxctrl"]], "id")}"
    volume_id       = "${lookup(data.oci_core_volumes.my_data_vols.volumes[each.value["idxctrl"]], "id")}"
}

#-OUTPUTS---------------------------------------------------------------------------------------------------
output "INSTANCE_com_DATA" {
    value   = "${lookup(data.oci_core_instances.data_inst.instances[0], "id")}"
}

output "INSTANCE_sem_DATA" {
    value = "${oci_core_instance.my_pub_instance}"
}

output "attachment_output" {
    depends_on  = ["oci_core_volume_attachment.attach_volume"]
    value       = "${oci_core_volume_attachment.attach_volume}"
}

#output "INSTANCE_FOR_output" {
#    depends_on      = ["oci_core_instance.my_pub_instance"]
#    value           = ["for value in oci_core_instance.my_pub_instance: value.id"]
#}

#output "VOLUME_FOR_output" {
#    depends_on      = ["oci_core_volume.create_volume"]
#    value           = ["for vol in oci_core_volume.create_volume: vol.id"]
#}