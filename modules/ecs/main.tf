### Provider Huawei Cloud ## 

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}


data "huaweicloud_networking_secgroup" "securitygroup" {
  name        = "${var.app_name}-${var.environment}-sg"
}

data "huaweicloud_images_image" "ecs_image" {
  name        = "${var.ecs_image_name}"
  visibility  = "${var.ecs_image_type}"
  most_recent = true
}

## Import an SSH Keypair ##
resource "huaweicloud_compute_keypair" "keypair" {
  name       = "${var.region}-keypair"
  public_key = file("${path.root}/id_rsa.pub")
}

## ECS Resource ## 
resource "huaweicloud_compute_instance" "ecs_generic_instance" {
  name                        = "${var.app_name}-${var.environment}-ecs"
  image_id                    = "${data.huaweicloud_images_image.ecs_image.id}"
  key_pair                    = "${huaweicloud_compute_keypair.keypair.id}"
  availability_zone           = "${var.availability_zone}"
  flavor_id                   = "${var.ecs_instance_type}"
  system_disk_type            = "${var.ecs_sysdisk_type}"
  system_disk_size            = "${var.ecs_sysdisk_size}"
  delete_disks_on_termination = true
  user_data                   = <<-EOF
#!/bin/bash
echo '${file("${path.root}/${var.remote_exec_filename}")}' > ${var.remote_exec_path}/${var.remote_exec_filename}
EOF

  network {
    uuid                      = "${data.huaweicloud_vpc_subnet.subnet.id}"
  }
  security_group_ids = [
    "${data.huaweicloud_networking_secgroup.securitygroup.id}"
  ]
}

## ECS - Data Disk ##
resource "huaweicloud_evs_volume" "datadisk" {
  name              = "datadisk"
  availability_zone = "${var.availability_zone}"
  volume_type       = "${var.ecs_datadisk_type}"
  size              = "${var.ecs_datadisk_size}"
}

## ECS - Attach Data Disk ##
resource "huaweicloud_compute_volume_attach" "attached" {
  instance_id = "${huaweicloud_compute_instance.ecs_generic_instance.id}"
  volume_id   = "${huaweicloud_evs_volume.datadisk.id}"
}


## ECS - Elastic IP Resource ##
resource "huaweicloud_vpc_eip" "instance_eip" {
  count          = "${var.ecs_attach_eip ? 1 : 0}"

  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.app_name}"
    size        = "${var.eip_bandwidth_size}"
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

## ECS - Elastic IP Associate Resource ##
resource "huaweicloud_compute_eip_associate" "associated" {
  count       = "${var.ecs_attach_eip ? 1 : 0}"
  public_ip   = "${element(huaweicloud_vpc_eip.instance_eip.*.address,count.index)}"
  instance_id = "${huaweicloud_compute_instance.ecs_generic_instance.id}"
}

