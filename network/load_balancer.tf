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
    subnet_ids      = [
        "${oci_core_subnet.public.id}"
    ]
    is_private      = false
}

output "load_balancer_id" {
    value   = "${oci_load_balancer_load_balancer.lb1.id}"
}

output "load_balancer_ip" {
    value   = "${oci_load_balancer_load_balancer.lb1.ip_address_details}"
}