// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

resource "oci_load_balancer_load_balancer" "lb1" {
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    display_name    = "${var.env_prefix}_lb"
    shape           = "${var.load_balancer_shape}"
    is_private      = false
    
    subnet_ids      = [
        "${oci_core_subnet.public.id}"
    ]
}

output "LoadBalancer_ID" {
    value   = "${oci_load_balancer_load_balancer.lb1.id}"
}

output "LoadBalancer_IP" {
    value   = "${oci_load_balancer_load_balancer.lb1.ip_address_details}"
}

resource "oci_load_balancer_backend_set" "lb1_bset" {
    name                = "${var.env_prefix}_backend_set"
    load_balancer_id    = "${oci_load_balancer_load_balancer.lb1.id}"
    policy              = "ROUND_ROBIN"

    health_checker  {
        protocol    = "${var.lb_backend_protocol}"
    }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  name                     = "${var.env_prefix}"
  load_balancer_id         = "${oci_load_balancer_load_balancer.lb1.id}"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb1_bset.name}"
  port                     = "${var.lb_listener_port}"
  protocol                 = "${var.lb_listener_protocol}"
}