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
    default = "TESTE"
}

// Nested Compartment Map:
//
variable "childmap" {
    type = "map"
    default = {
        _XNetwork_Comp   = "Network Compartment"
        _XCompute_Comp   = "Compute Compartment"
        _XStorage_Comp   = "Storage Compartment"
    }
}

// Policy Statements
variable "PolicyMap" {
    type = "map"
    default = {
        Network_Policy = {
            statement_1 = "Allow group TESTENetwork_Group to manage instance-family in compartment TESTE_Compartment:TESTE_XNetwork_Comp",
            statement_2 = "Allow group TESTENetwork_Group to manage volume-family in compartment TESTE_Compartment:TESTE_XNetwork_Comp"
        }
        Compute_Polcy = {
            statement_1 = "Allow group TESTECompute_Group to manage instance-family in compartment TESTE_Compartment:TESTE_XCompute_Comp",
            statement_2 = "Allow group TESTECompute_Group to manage volume-family in compartment TESTE_Compartment:TESTE_XCompute_Comp"
        }
        Storage_Polcy = {
            statement_1 = "Allow group TESTEStorage_Group to manage instance-family in compartment TESTE_Compartment:TESTE_XStorage_Comp",
            statement_2 = "Allow group TESTEStorage_Group to manage instance-family in compartment TESTE_Compartment:TESTE_XStorage_Comp"
        }
    }
}

// TAG Namespace variable:
//
variable "terra_tag_ns" {
    default = "tag_ns_teste1"
}

// TAG Key variable:
//
variable "terra_tag_key" {
    default = "tag_key_teste1"
}

// TAG value variable:
//
variable "terra_tag_value" {
    default = "tag_value_teste1"
}

// Map of Group in Environment Prefix:
//
variable "group_map" {
    type = "map"
    default = {
        Network = "Network Group Admin"
        Compute = "Compute Group Admin"
        Storage = "Storage Group Admin"
        Admin   = "This Group is a Environment Admin"
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

// SSH public Key
// PS.: Working to extract from file
//
variable "ssh_public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1EDq34mbfQkE4P5Pq2hFPAirRBqD3o/eAyh55FxsYobnEgjFk6fJS5UKd4jOBJhm12kjJEgotblwePCqbTKIFudXVl0VwW2QgswgSqSnc5InEyHzsSfztJ3yaaGocSVMtNUtMIFcw6ICsghkYB2swsUMY8qj0vV0qLsHEZ8Xr7Ti6ae8iDGfmJ2zf/lG7oUSlYO52pqFrT9T9ThSRpJAxM2d2PXy/cVhBn8QQoaIuUdjbZVkH94cGwlxhqwIJYO6aNDjKivrDNSb1VQY/PcLhPUFXdXxwpOBL2tUC1vkjujcdHtOgCb8mwS+Z2W4zjZ3d7oBgE4VgRNnD3vIMymSPw=="
}

// Server List Teste
//
variable "server_list" {
    type    = "map"
    default = {
        inst1    = {
            name    = "ServName1",
            ad      = "hSxN:US-ASHBURN-AD-1",
            shape   = "VM.Standard2.1",
            image   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda",
            volname = "ServName1Vol01",
            volsize = "50",
            pubip   = "true"
        }

        inst2    = {
            name    = "ServName2",
            ad      = "hSxN:US-ASHBURN-AD-2",
            shape   = "VM.Standard2.1",
            image   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda",
            volname = "ServName2Vol01",
            volsize = "50",
            pubip   = "true"
        }
    }
}