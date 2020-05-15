# Terraform v0.12 is assumed
// Created by Bruno Viscaino

variable "PolicyMap" {
    type = "map"
    default = {
        Network_Policy = {
            statement_1 = "Allow group ProdNetwork_Group to manage instance-family in compartment Prod_Compartment:ProdNestedNet",
            statement_2 = "Allow group ProdNetwork_Group to manage volume-family in compartment Prod_Compartment:ProdNestedNet"
        }
        Compute_Polcy = {
            statement_1 = "Allow group ProdNetwork_Group to manage instance-family in compartment Prod_Compartment:ProdNestedCompute",
            statement_2 = "Allow group ProdNetwork_Group to manage volume-family in compartment Prod_Compartment:ProdNestedCompute"
        }
        Storage_Polcy = {
            statement_1 = "Allow group ProdNetwork_Group to manage instance-family in compartment Prod_Compartment:ProdNestedStorage",
            statement_2 = "Allow group ProdNetwork_Group to manage instance-family in compartment Prod_Compartment:ProdNestedStorage"
        }
    }
}

resource "oci_identity_policy" "create_policy" {
    for_each        = "${var.PolicyMap}"
    depends_on      = ["oci_identity_compartment.child_compartment"]
    name            = "${each.key}"
    description     = "${each.key}"
    compartment_id  = "${var.root_compartment}"
    statements      = [
        "${each.value["statement_1"]}",
        "${each.value["statement_2"]}"
    ]
}