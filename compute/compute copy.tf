# Terraform v0.12 is assumed
// Created by Bruno Viscaino

###################################################################
##
##      COMPUTE INSTANCE
##      This block deploy a unique compute instance:
##
##      PS: We are working to create a map for AD selection.
##      PS: Create a randomic AD distribution
##
###################################################################

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = 1
}

data "oci_identity_compartments" "my_compute_comp" {
    depends_on  = ["oci_identity_compartment.child_compartment"]
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["${var.env_prefix}\\w*Compute"]
        regex   = true
    }
}

output "my_compute_comp_output" {
    depends_on = ["data.oci_identity_compartments.my_compute_comp"]
    value      = "${data.oci_identity_compartments.my_compute_comp.compartments}"
}

resource "oci_core_instance" "my_pub_instance" {
    for_each            = "${var.server_list}"
    depends_on          = ["oci_core_subnet.public"]
    availability_domain = "${data.oci_identity_availability_domain.ad.name}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
    display_name        = "${each.value["name"]}"
    shape               = "${each.value["shape"]}"

    source_details {
        source_type = "image"
        source_id   = "${each.value["image"]}"
    }

    create_vnic_details {
        subnet_id           = "${oci_core_subnet.public.id}"
        display_name        = "${each.key}_pubvnic"
        assign_public_ip    = "${each.value["pubip"]}"
    }
    
    metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
    }
}

resource "oci_core_volume" "create_volume" {
    for_each            = "${var.volume_map}"
    depends_on          = ["oci_core_instance.my_pub_instance"]
    availability_domain = "${data.oci_identity_availability_domain.ad.name}"
    compartment_id      = "${lookup(data.oci_identity_compartments.my_compute_comp.compartments[0], "id")}"
    display_name        = "${each.value["vol_name"]}"
    size_in_gbs         = "${each.value["volsize"]}"
}