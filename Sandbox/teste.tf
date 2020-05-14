provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

// OCI Region Definition:
variable "region" {
    default = "us-ashburn-1"
}

// Customer Tenancy Definition:
variable "tenancy_id" {
    default = "ocid1.tenancy.oc1..aaaaaaaa7ojo7t7hedpsnqglouvvvxuakdxtkhb2t542pf5dch4ly2lprcla"
}

// Customer Compartment Definition:
// PS: For the first execution use the Root Compartment.
variable "compartment_id" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

variable "CompList" {
    type = "map"
    default = {
        Comp_A = "Desc_A"
        Comp_B = "Desc_B"
    }
}

variable "NestList" {
    type = "map"
    default = {
        Compute = "Desc_A"
        Network = "Desc_B"
    }
}

resource "oci_identity_compartment" "create_compartment" {
    for_each        = "${var.CompList}"
    compartment_id  = "${var.compartment_id}"
    name            = "${each.key}"
    description     = "${each.value}"
}
data "oci_identity_compartments" "DataCompSList" {
  compartment_id = "${var.compartment_id}"
}
output "out_DataCompList" {
 // value     = "${lookup(data.oci_identity_compartments.DataCompList[0],"name")}"
  value = ["${data.oci_identity_compartments.DataCompList}"]
}

output "out_DataCompSList" {
  value = ["${lookup(data.oci_identity_compartments.DataCompSList[0], "compartment_id")}"]
}



###################################################3


resource "oci_identity_compartment" "create_compartment" {
    for_each        = "${var.CompList}"
    compartment_id  = "${var.compartment_id}"
    name            = "${each.key}"
    description     = "${each.value}"
}

output "out_DataCompList" {
 // value     = "${lookup(data.oci_identity_compartments.DataCompList[0],"name")}"
  value = ["${data.oci_identity_compartments.DataCompList}"]
}

resource "oci_identity_compartment" "create_compartment" {
    for_each        = "${var.CompList}"
    compartment_id  = "${var.compartment_id}"
    name            = "${each.key}"
    description     = "${each.value}"
}
