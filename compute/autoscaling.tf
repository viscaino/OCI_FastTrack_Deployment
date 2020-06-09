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

resource "oci_core_instance_pool" "instance_pool" {
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
    size            = "${var.instance_pool_size}"
    state           = "RUNNING"
    display_name    = "${var.env_prefix}${var.instance_pool_name}"
    instance_configuration_id   = "${oci_core_instance_configuration.inst_config.id}"

    placement_configurations {
        availability_domain = "${var.instance_pool_AD}"
        primary_subnet_id   = "${oci_core_subnet.public.id}"
    }
}

resource "oci_autoscaling_auto_scaling_configuration" "autoscaling_config" {
    depends_on          = [
        "oci_core_instance_pool.instance_pool"
    ] 
    compartment_id          = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
    cool_down_in_seconds    = "300"
    display_name            = "${var.env_prefix}${var.autoscaling_display_name}"
    is_enabled              = true

    auto_scaling_resources {
        id      = "${oci_core_instance_pool.instance_pool.id}"
        type    = "instancePool"
    }

    policies {
    
        display_name    = "${var.env_prefix}_AutoscalingPolicy"
        policy_type     = "threshold"

        capacity {
            initial = "${var.capacity_initial}"
            max     = "${var.capacity_max}"
            min     = "${var.capacity_min}"
        }
              
        rules {
            
            display_name    = "${var.env_prefix}_Scale_OUT_Rule"
            
            action {
                type    = "CHANGE_COUNT_BY"
                value   = "1"
            }
            
            metric {
                metric_type = "${var.ScaleOutMetric}"
                threshold {
                    operator    = "${var.ScaleOutOperator}"
                    value       = "${var.ScaleOutValue}"
                }
            }
        }

        rules {

            display_name    = "${var.env_prefix}_Scale_IN_Rule"

            action {
                type    = "CHANGE_COUNT_BY"
                value   = "-1"
            }
            metric {
                metric_type = "${var.ScaleInMetric}"
                threshold {
                    operator    = "${var.ScaleInOperator}"
                    value       = "${var.ScaleInValue}"
                }
            }
        }
    }
}