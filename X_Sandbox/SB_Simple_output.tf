provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}

variable "region" {
    default = "us-ashburn-1"
}

data "oci_core_instances" "my_instances" {
    compartment_id  = "ocid1.compartment.oc1..aaaaaaaaxr7fb2uc6ufsqgmpr6omtxidbfvpoxfpkw7ic7gtivgauganed6q"

    filter {
        name    = "state"
        values  = ["RUNNING"]
    }
}

output "OUTPUT_my_instances_resource_ip" {
    value = "${oci_core_instance.my_pub_instance.public_ip}"
}

output "OUTPUT_my_instances_resource_brakets" {
    value = ["${oci_core_instance.my_pub_instance.public_ip}"]
}

output "OUTPUT_my_instances_data_ip" {
    value = ["${data.oci_core_instances.my_instances.*.instances}"]
}