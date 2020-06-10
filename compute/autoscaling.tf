// 2020, Terradorm file created by Bruno Viscaino

resource "oci_autoscaling_auto_scaling_configuration" "autoscaling_config" {
    depends_on              = [
        "oci_core_instance_pool.instance_pool"
#        "oci_core_instance_configuration.inst_config"
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