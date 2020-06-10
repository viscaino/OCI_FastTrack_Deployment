// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

resource "oci_load_balancer_listener" "lb-listener1" {
  name                     = "${var.env_prefix}"
  load_balancer_id         = "${oci_load_balancer_load_balancer.lb1.id}"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb1_bset.name}"
  port                     = "${var.lb_listener_port}"
  protocol                 = "${var.lb_listener_protocol}"
}