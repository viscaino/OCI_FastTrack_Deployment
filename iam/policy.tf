# Terraform v0.12 is assumed
// Created by Bruno Viscaino
###-!!WARNING!!-####################################################
##
##      !!WARNING!! POLICY BLOCK
##      The policies included in this block is a PRE-DEFINED  
##      POLICY STATEMENTS. We are developing a block that is 
##      able to create dynamic policy statements.
##      
###################################################################

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

resource "oci_identity_policy" "create_policy" {
    for_each        = "${var.PolicyMap}"
    depends_on      = [
        "oci_identity_compartment.child_compartment",
        "oci_identity_group.groups"
        ]
    name            = "${each.key}"
    description     = "${each.key}"
    compartment_id  = "${var.root_compartment}"
    statements      = [
        "${each.value["statement_1"]}",
        "${each.value["statement_2"]}"
    ]
}