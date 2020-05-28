// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

# Defines the number of instances to deploy
variable "num_instances" {
  default = "3"
}

# Defines the number of volumes to create and attach to each instance
# NOTE: Changing this value after applying it could result in re-attaching existing volumes to different instances.
# This is a result of using 'count' variables to specify the volume and instance IDs for the volume attachment resource.
variable "num_iscsi_volumes_per_instance" {
  default = "1"
}

variable "num_paravirtualized_volumes_per_instance" {
  default = "2"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"

    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaitzn6tdyjer7jl34h2ujz74jwy5nkbukbh55ekp6oyzwrtfa4zma"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa32voyikkkzfxyo4xbdmadc2dmvorfxxgdhpnk6dw64fa3l4jh7wa"
  }
}

variable "db_size" {
  default = "50" # size in GBs
}

resource "oci_core_instance" "test_instance" {
  count               = "${var.num_instances}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TestInstance${count.index}"
  shape               = "${var.instance_shape}"

  shape_config {
    ocpus = "${var.instance_ocpus}"
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.test_subnet.id}"
    display_name     = "Primaryvnic"
    assign_public_ip = true
    hostname_label   = "tfexampleinstance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./userdata/bootstrap"))}"
  }
}

# Define the volumes that are attached to the compute instances.

resource "oci_core_volume" "test_block_volume" {
  count               = "${var.num_instances * var.num_iscsi_volumes_per_instance}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TestBlock${count.index}"
  size_in_gbs         = "${var.db_size}"
}

resource "oci_core_volume_attachment" "test_block_attach" {
  count           = "${var.num_instances * var.num_iscsi_volumes_per_instance}"
  attachment_type = "iscsi"
  instance_id     = "${oci_core_instance.test_instance.*.id[floor(count.index / var.num_iscsi_volumes_per_instance)]}"
  volume_id       = "${oci_core_volume.test_block_volume.*.id[count.index]}"
  device          = "${count.index == 0 ? "/dev/oracleoci/oraclevdb" : ""}"

  # Set this to enable CHAP authentication for an ISCSI volume attachment. The oci_core_volume_attachment resource will
  # contain the CHAP authentication details via the "chap_secret" and "chap_username" attributes.
  use_chap = true

  # Set this to attach the volume as read-only.
  #is_read_only = true
}


resource "oci_core_volume_backup_policy_assignment" "policy" {
  count     = 2
  asset_id  = "${oci_core_instance.test_instance.*.boot_volume_id[count.index]}"
  policy_id = "${data.oci_core_volume_backup_policies.test_predefined_volume_backup_policies.volume_backup_policies.0.id}"
}

resource "null_resource" "remote-exec" {
  depends_on = ["oci_core_instance.test_instance", "oci_core_volume_attachment.test_block_attach"]
  count      = "${var.num_instances * var.num_iscsi_volumes_per_instance}"

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${oci_core_instance.test_instance.*.public_ip[count.index % var.num_instances]}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "touch ~/IMadeAFile.Right.Here",
      "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -p ${oci_core_volume_attachment.test_block_attach.*.ipv4[count.index]}:${oci_core_volume_attachment.test_block_attach.*.port[count.index]}",
      "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -n node.startup -v automatic",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -p ${oci_core_volume_attachment.test_block_attach.*.ipv4[count.index]}:${oci_core_volume_attachment.test_block_attach.*.port[count.index]} -o update -n node.session.auth.authmethod -v CHAP",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -p ${oci_core_volume_attachment.test_block_attach.*.ipv4[count.index]}:${oci_core_volume_attachment.test_block_attach.*.port[count.index]} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.test_block_attach.*.chap_username[count.index]}",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -p ${oci_core_volume_attachment.test_block_attach.*.ipv4[count.index]}:${oci_core_volume_attachment.test_block_attach.*.port[count.index]} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.test_block_attach.*.chap_secret[count.index]}",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.test_block_attach.*.iqn[count.index]} -p ${oci_core_volume_attachment.test_block_attach.*.ipv4[count.index]}:${oci_core_volume_attachment.test_block_attach.*.port[count.index]} -l",
    ]
  }
}

# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "test_boot_volume_attachments" {
  depends_on          = ["oci_core_instance.test_instance"]
  count               = "${var.num_instances}"
  availability_domain = "${oci_core_instance.test_instance.*.availability_domain[count.index]}"
  compartment_id      = "${var.compartment_ocid}"

  instance_id = "${oci_core_instance.test_instance.*.id[count.index]}"
}

data "oci_core_instance_devices" "test_instance_devices" {
  count       = "${var.num_instances}"
  instance_id = "${oci_core_instance.test_instance.*.id[count.index]}"
}

data "oci_core_volume_backup_policies" "test_predefined_volume_backup_policies" {
  filter {
    name = "display_name"

    values = [
      "silver",
    ]
  }
}

# Output the private and public IPs of the instance

output "instance_private_ips" {
  value = ["${oci_core_instance.test_instance.*.private_ip}"]
}

output "instance_public_ips" {
  value = ["${oci_core_instance.test_instance.*.public_ip}"]
}

# Output the boot volume IDs of the instance
output "boot_volume_ids" {
  value = ["${oci_core_instance.test_instance.*.boot_volume_id}"]
}

# Output all the devices for all instances
output "instance_devices" {
  value = ["${data.oci_core_instance_devices.test_instance_devices.*.devices}"]
}

# Output the chap secret information for ISCSI volume attachments. This can be used to output
# CHAP information for ISCSI volume attachments that have "use_chap" set to true.
#output "IscsiVolumeAttachmentChapUsernames" {
#  value = ["${oci_core_volume_attachment.test_block_attach.*.chap_username}"]
#}
#
#output "IscsiVolumeAttachmentChapSecrets" {
#  value = ["${oci_core_volume_attachment.test_block_attach.*.chap_secret}"]
#}

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = 1
}