// 2020, Terradorm file created by Bruno Viscaino

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
    description = "include private key into userdata directory"
    default     = "userdata/id_rsa"
}

variable "instance_ip" {}

#-------------------------------------------------------------------------------------------
resource "null_resource" "remote-exec" {

    provisioner "remote-exec" {
        connection {
            agent       = false
            timeout     = "5m"
            host        = "${var.instance_ip}"
            user        = "opc"
            private_key = "${file(var.ssh_private_key)}"
        }
        inline = ["touch /tmp/File_Wrote_by_Terraform"]
    }
}