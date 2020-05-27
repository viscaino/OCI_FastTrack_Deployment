provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}

#-----------------------------------------------------------------------------------------------------------------

variable "region" {
    default = "us-ashburn-1"
}

variable "tenancy_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaa7ojo7t7hedpsnqglouvvvxuakdxtkhb2t542pf5dch4ly2lprcla"
}

variable "compartment_ocid" {
    default = "ocid1.compartment.oc1..aaaaaaaa2dl2qmbzsuypndcztadjtvzntzb7zf5yx7phl6zualuw7tfc2puq"
}

variable "ssh_public_key" {
    default = "userdata/id_rsa.pub"
}

#-----------------------------------------------------------------------------------------------------------------

resource "oci_core_vcn" "create_vcn" {
    display_name    = "TESTE_VCN_01"
    cidr_block      = "192.0.0.0/16"
    compartment_id  = "${var.compartment_ocid}"
}

resource "oci_core_internet_gateway" "create_igw" {
    depends_on      = ["oci_core_vcn.create_vcn"]
    display_name    = "TESTE_IGW_01"
    compartment_id  = "${var.compartment_ocid}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"
}

resource "oci_core_security_list" "seclist_public" {
    depends_on          = ["oci_core_vcn.create_vcn"]
    compartment_id      = "${var.compartment_ocid}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    display_name        = "TESTE_SECLIST_01"

    ingress_security_rules {
        protocol    = "6"
        source      = "0.0.0.0/0"

        tcp_options {
            min     = "22"
            max     = "22"
        }
    }

    egress_security_rules {
        protocol    = "6"
        destination = "0.0.0.0/0"

        tcp_options {
            min     = "22"
            max     = "22"
        }        
    }
}

resource "oci_core_route_table" "public" {
    display_name    = "TESTE_ROUTE_01"
    compartment_id  = "${var.compartment_ocid}"
    vcn_id          = "${oci_core_vcn.create_vcn.id}"

    route_rules {
        destination         = "0.0.0.0/0"
        network_entity_id   = "${oci_core_internet_gateway.create_igw.id}"
    }
}

resource "oci_core_subnet" "public" {    
    depends_on      = [
        "oci_core_vcn.create_vcn",
        "oci_core_route_table.public"
        ]
    display_name        = "TESTE_SUBNET_01"
    compartment_id      = "${var.compartment_ocid}"
    vcn_id              = "${oci_core_vcn.create_vcn.id}"
    cidr_block          = "192.0.1.0/24"
    route_table_id      = "${oci_core_route_table.public.id}"
    security_list_ids   = ["${oci_core_security_list.seclist_public.id}"]
}

resource "oci_core_instance" "instance01" {
  availability_domain = "hSxN:US-ASHBURN-AD-1"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "instance01"
  shape               = "VM.Standard.E2.1"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.public.id}"
    display_name     = "Primaryvnic"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key)}"
  }
}


resource "oci_core_instance" "instance02" {
  availability_domain = "hSxN:US-ASHBURN-AD-1"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "instance02"
  shape               = "VM.Standard.E2.1"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.public.id}"
    display_name     = "Primaryvnic"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key)}"
  }
}