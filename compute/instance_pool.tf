// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

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