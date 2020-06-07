// 2020, Terradorm file created by Bruno Viscaino

provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}