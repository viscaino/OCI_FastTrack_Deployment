# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino

// OCI Region Definition:
//
variable "region" {
    default = "us-ashburn-1"
}

// OCI Customer Tenancy OCID:
//
variable "tenancy_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaa7ojo7t7hedpsnqglouvvvxuakdxtkhb2t542pf5dch4ly2lprcla"
}

// Root Compartment:
//
variable "root_compartment" {
    default = "ocid1.compartment.oc1..aaaaaaaajvl5gaimqv2wni7jrftdxiyxxqubes6jlixadm43mn75kav5p7qq"
}

// Environment in use:
//
variable "env_prefix" {
    default = "Test"
}

// Nested Compartment Map:
//
variable "childmap" {
    type = "map"
    default = {
        _Network_Comp  = "Network Compartment"
        _Compute_Comp  = "Compute Compartment"
        _Storage_Comp  = "Storage Compartment"
        _Database_Comp = "Database Compartment"
    }
}

// Policy Statements
variable "PolicyMap" {
    type = "map"
    default = {
        Network_Policy = {
            statement_1 = "Allow group Test_Network_Group to use instance-family in compartment Test_Compartment:Test_Network_Comp",
            statement_2 = "Allow group Test_Network_Group to manage volume-family in compartment Test_Compartment:Test_Network_Comp"
        }
        Compute_Polcy = {
            statement_1 = "Allow group Test_Compute_Group to manage instance-family in compartment Test_Compartment:Test_Compute_Comp",
            statement_2 = "Allow group Test_Compute_Group to use volume-family in compartment Test_Compartment:Test_Compute_Comp"
        }
        Storage_Polcy = {
            statement_1 = "Allow group Test_Storage_Group to manage volume-family in compartment Test_Compartment:Test_Storage_Comp",
            statement_2 = "Allow group Test_Storage_Group to use instance-family in compartment Test_Compartment:Test_Storage_Comp"
        }
    }
}

// TAG Namespace variable:
//
variable "terra_tag_ns" {
    default = "TagNS"
}

// TAG Key variable:
//
variable "terra_tag_key" {
    default = "TagKey"
}

// TAG value variable:
//
variable "terra_tag_value" {
    default = "TagValue"
}

// Map of Group in Environment Prefix:
//
variable "group_map" {
    type = "map"
    default = {
        _Network = "Network Group Admin"
        _Compute = "Compute Group Admin"
        _Storage = "Storage Group Admin"
        _Database = "Database Group Admin"
        _Admin   = "This Group is a Environment Admin"
    }
}

// VCN Name:
//
variable "vcn_name" {
    default = "vcn"
}

// VCN CIDR:
//
variable "vcn_cidr" {
    default = "10.0.0.0/16"
}

// Private Subnet Name:
//
variable "private_subnet_name" {
    default = "Priv_subnet"
}

// Private Subnet CIDR:
//
variable "private_subnet_cidr" {
    default = "10.0.1.0/24"
}

// Private Route Table Name:
//
variable "priv_route_tab_name" {
    default = "Priv_RT"
}

// Private Security List Name:
//
variable "private_seclist_name" {
    default = "Priv_SecList"
}

// Public Subnet Name:
//
variable "public_subnet_name" {
    default = "Pub_subnet"
}

// Public Subnet CIDR:
//
variable "public_subnet_cidr" {
    default = "10.0.2.0/24"
}

// Public Route Table Name:
//
variable "pub_route_tab_name" {
    default = "Pub_RT"
}

// Public Security List Name:
//
variable "public_seclist_name" {
    default = "Pub_SecList"
}

// SSH Public Key
//
variable "ssh_public_key" {
    default = "userdata/id_rsa.pub"
}

// SSH private Key
//
variable "ssh_private_key" {
    default = "userdata/id_rsa"
}

// Server List Teste
//
variable "server_list" {
    type    = "map"
    default = {
        inst0    = {
            name    = "ServName1",
            ad      = "hSxN:US-ASHBURN-AD-1",
            shape   = "VM.Standard2.1",
            image   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda",
            volname = "ServName1Vol01",
            volsize = "50",
            idxctrl = "0",
            pubip   = "true"
        }

       inst1    = {
           name    = "ServName2",
           ad      = "hSxN:US-ASHBURN-AD-2",
           shape   = "VM.Standard2.1",
           image   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda",
           volname = "ServName2Vol01",
           volsize = "50",
           idxctrl = "1",
           pubip   = "true"
       }
    }
}

// Autonomous DB workload
variable "adb_workload" {
    default = "OLTP"
}

// Autonomous DB Name
variable "adb_name" {
    default = "adbdb01"
}

// Autonomous DB Autoscaling policy
variable "adb_autoscaling" {
    default = "false"
}

// Autonomous DB License
variable "adb_license_model" {
  default = "LICENSE_INCLUDED"
}

// Security List Rules
variable "pub_seclist_ingress_rules" {
    type = "map"
    default = {
        role001 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "22",
            max         = "22"
        }
        role002 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "80",
            max         = "80"
        }
    }
}

variable "pub_seclist_egress_rules" {
    type = "map"
    default = {
        role001 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "22",
            max         = "22"
        }
        role002 = {
            protocol    = "6",
            source      = "0.0.0.0/0",
            min         = "80",
            max         = "80"
        }
    }
}