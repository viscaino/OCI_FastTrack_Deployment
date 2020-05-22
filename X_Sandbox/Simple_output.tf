output "my_parent_compartment" {
    value = "${oci_identity_compartment.parent_compartment.id}"
}

data "oci_identity_compartments" "my_data_comp" {
    compartment_id  = "${oci_identity_compartment.parent_compartment.id}"

    filter {
        name    = "name"
        values  = ["\\w*Network"]
        regex   = true
    }
}

output "my_data_comp_output" {
    value   = "${data.oci_identity_compartments.my_data_comp.compartments}"
}

output "my_data_comp_output_id" {
    value   = "${lookup(data.oci_identity_compartments.my_data_comp.compartments[0], "id")}"
}