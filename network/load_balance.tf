// 2020, Terradorm file created by Bruno Viscaino
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###
###--!! WORKING IN PROGRESS !!--###

resource "oci_load_balancer" "lb1" {
    shape           = "100Mbps"
    compartment_id  = "${lookup(oci_identity_compartment.child_compartment["Network"], "id")}"
    subnet_ids      = [
        "${oci_core_subnet.public.id}"
    ]
    display_name    = "${var.env_prefix}_loadbalance"
}

resource "oci_load_balancer_backend_set" "lb1_bset" {
    name                = "${var.env_prefix}_backend_set"
    load_balancer_id    = "${oci_load_balancer.lb1.id}"
    policy              = "ROUND_ROBIN"
    

    health_checker      = {
        port        = "80"
        protocol    = "HTTP"
        url_path    = "/"
        response_body_regex = ".*"
    }
}