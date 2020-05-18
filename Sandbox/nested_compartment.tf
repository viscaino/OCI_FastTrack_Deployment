# Terraform v0.12 is assumed
// This TF File is used to deploy compartments.
// Created by Bruno Viscaino
###################################################################
##
##      WORKING IN PROGRESS
##      we expect to created nested compartments
##      based on three (3) main compartments:
##
##      Prod_Compartment
##      |
##      |_NetworkCompartment
##      |_StorageCompartment
##      |_ComputeCompartment
##
##      Repeat it for QA and Dev
##
###################################################################
##
##  Thinking to solve this request by:
##
##      1- Create a DataSource to get Compartments.
##      2- Use a conditional lookup by tag.
##      3- Create a zipmap.
##      4- Use a zipmap as a source for a for_each function
##         into a resource.
##
###################################################################


/*
locals {
    subcomp     = "${flatten ([
        for maincomp_key, maincomp in var.CompartmentMapMain :[
            for subcomp_key, subcomp in maincomp.subcomp : {
                maincomp_key    =   maincomp_key
                subcomp_key     =   subcomp_key
                compartment_id  =   oci_identity_compartment.main_compartment[maincomp_key].id
                name            =   subcomp.name
            }
        ]
    ])}"
}
*/