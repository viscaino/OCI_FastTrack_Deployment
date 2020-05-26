provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}

#-------------------------------------------------------------------------------------------

variable "region" {
    default = "us-ashburn-1"
}

variable "ssh_private_key" {
    default = "id_rsa"
}

#-------------------------------------------------------------------------------------------
resource "null_resource" "remote-exec" {
#  depends_on = ["oci_core_volume_attachment.attach_volume"] 

    provisioner "remote-exec" {
        connection {
            agent       = false
            timeout     = "30m"
            host        = "129.213.55.126"
            user        = "opc"
            private_key = "${file(var.ssh_private_key)}"
        }
        inline = ["touch /tmp/IMadeAFile.Right.Here"]
    }
}