

terraform {
  required_providers {
    cml2 = {
      source  = "CiscoDevNet/cml2"
      version = "0.5.3"
    }
  }
}

provider "cml2" {
  address  = "https://REPLACE_ME"
  username = "REPLACE_ME"
  password = "REPLACE_ME"
  skip_verify = true
}
resource "cml2_lab" "demo_1" {
  title       = "3 Tier Network Terraform define mode"
  description = "Dummy TF Lab"
}
resource "cml2_node" "aggr1" {
  lab_id         = cml2_lab.demo_1.id
  label          = "aggr1"
  nodedefinition = "nxosv9000"
  cpus = 2
  x = 0
  y = 0
}
resource "cml2_node" "aggr2" {
  lab_id         = cml2_lab.demo_1.id
  label          = "aggr2"
  nodedefinition = "nxosv9000"
  cpus = 2
  x = 300
  y = 0
}
resource "cml2_node" "core1" {
  lab_id         = cml2_lab.demo_1.id
  label          = "core1"
  nodedefinition = "iosxrv9000"
  cpus = 4
  x = 0
  y = 300
}
resource "cml2_node" "core2" {
  lab_id         = cml2_lab.demo_1.id
  label          = "core2"
  nodedefinition = "iosxrv9000"
  cpus = 4
  x = 300
  y = 300
}
resource "cml2_node" "access1" {
  lab_id         = cml2_lab.demo_1.id
  label          = "access1"
  nodedefinition = "nxosv9000"
  cpus = 2
  x = 0
  y = -300
}
resource "cml2_node" "access2" {
  lab_id         = cml2_lab.demo_1.id
  label          = "access2"
  nodedefinition = "nxosv9000"
  cpus = 2
  x = 300
  y = -300
}
resource "cml2_link" "l0" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr1.id
  slot_a = 1
  node_b = cml2_node.access1.id
  slot_b = 1
}
resource "cml2_link" "l1" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr1.id
  slot_a = 2
  node_b = cml2_node.access2.id
  slot_b = 1
}
resource "cml2_link" "l2" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr2.id
  slot_a = 1
  node_b = cml2_node.access1.id
  slot_b = 2
}
resource "cml2_link" "l3" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr2.id
  slot_a = 2
  node_b = cml2_node.access2.id
  slot_b = 2
}
resource "cml2_link" "l4" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr1.id
  slot_a = 5
  node_b = cml2_node.aggr2.id
  slot_b = 5
}
resource "cml2_link" "l5" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.access1.id
  slot_a = 5
  node_b = cml2_node.access2.id
  slot_b = 5
}
resource "cml2_link" "l6" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr1.id
  slot_a = 6
  node_b = cml2_node.core1.id
  slot_b = 3
}
resource "cml2_link" "l7" {
  lab_id = cml2_lab.demo_1.id
  node_a = cml2_node.aggr2.id
  slot_a = 6
  node_b = cml2_node.core2.id
  slot_b = 3
}
resource "cml2_lifecycle" "lab_status" {
  lab_id = cml2_lab.demo_1.id
  elements = [
    cml2_node.aggr1.id,
    cml2_node.aggr2.id,
    cml2_node.access1.id,
    cml2_node.access2.id,
    cml2_node.core1.id,
    cml2_node.core2.id
  ]
  wait = false
  state = "STARTED"
}
