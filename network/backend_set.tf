// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

resource "oci_load_balancer_backend_set" "lb1_bset" {
    name                = "${var.env_prefix}_backend_set"
    load_balancer_id    = "${oci_load_balancer_load_balancer.lb1.id}"
    policy              = "ROUND_ROBIN"

    health_checker  {
        protocol    = "${var.lb_backend_protocol}"
    }
}