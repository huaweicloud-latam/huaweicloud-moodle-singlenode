### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
}

### Create VPC ###
resource "huaweicloud_vpc" "vpc" {
  region        = "${var.region}"
  name          = "${var.vpc_name}"
  cidr          = "${var.vpc_cidr}"
  tags          = "${var.tags}"

}

### Create subnet ###
resource "huaweicloud_vpc_subnet" "subnet" {
  name          = "${var.subnet_name}"
  cidr          = "${var.subnet_cidr}"
  gateway_ip    = "${var.subnet_gateway_ip}"
  vpc_id        = "${huaweicloud_vpc.vpc.id}"
  dns_list      = "${var.dns_list}"
  tags          = "${var.tags}"
}

## Security Group Resource ##
resource "huaweicloud_networking_secgroup" "securitygroup" {
  region      = "${var.region}"
  name        = "${var.app_name}-${var.environment}-sg"
  description = "${var.app_name}-${var.environment} security group"
}

## Security Group Rule Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_vpc" {
  count             = "${length(var.ports-ranges)}"
  region            = "${var.region}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = "${var.ports-ranges[count.index]}"
  port_range_max    = "${var.ports-ranges[count.index]}"
  protocol          = "tcp"
  remote_ip_prefix  = "${var.remote_ip_prefix}"
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}

### VPC Route to server##
#resource "huaweicloud_vpc_route" "vpc_route_server" {
#  type        = "server"
#  nexthop     = "${var.nexthop}"
#  destination = "10.0.0.0/24"
#  vpc_id      = "${huaweicloud_vpc.vpc.id}"
#}


### NATGATEWAY ##





