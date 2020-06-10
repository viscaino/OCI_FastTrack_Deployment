// 2020, Terradorm file created by Bruno Viscaino

resource "oci_core_instance_pool" "instance_pool" {
    depends_on              = [
        "oci_load_balancer_load_balancer.lb1",
        "oci_load_balancer_backend_set.lb1_bset"
    ]
    compartment_id          = "${lookup(oci_identity_compartment.child_compartment["Compute"], "id")}"
    size                    = "${var.instance_pool_size}"
    state                   = "RUNNING"
    display_name            = "${var.env_prefix}${var.instance_pool_name}"
    instance_configuration_id   = "${oci_core_instance_configuration.inst_config.id}"
    
    load_balancers {
        load_balancer_id    = "${oci_load_balancer_load_balancer.lb1.id}"
        backend_set_name    = "${oci_load_balancer_backend_set.lb1_bset.name}"
        port                = "${var.load_balancer_port}"
        vnic_selection      = "Primary VNIC"
    }
    
    placement_configurations {
        availability_domain = "${var.instance_pool_AD}"
        primary_subnet_id   = "${oci_core_subnet.public.id}"
    }
}