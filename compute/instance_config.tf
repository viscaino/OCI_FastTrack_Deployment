// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

resource "oci_core_instance_configuration" "inst_config" {
    depends_on          = [
        "oci_core_instance.my_pub_instance"
    ] 
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
    display_name    = "${var.env_prefix}${var.instconfig_name}"
    
    instance_details    {
        instance_type   = "compute"

        launch_details  {
            compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
            shape           = "${var.instconfig_shape}"
            display_name    = "${var.env_prefix}${var.instconfig_launch_name}"

            create_vnic_details {
                assign_public_ip    = true
                display_name        = "${var.env_prefix}${var.instconfig_launch_name}_pubvnic"
            }
            
            extended_metadata = {
                some_string   = "stringA"
                nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
            }
                        
            source_details {
                source_type = "image"
                image_id    = "${var.instconfig_image}"
            }
            
        }
    }
}