### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
}

data "huaweicloud_compute_instance" "ecs_generic_instance" {
  name        = "${var.app_name}-${var.environment}-ecs"
}

resource "huaweicloud_cbr_policy" "cbr_server_policy" {
  name        = var.cbr_server_policy
  type        = "backup"
  time_period = 90

  backup_cycle {
    interval        = 1
    execution_times = ["00:00"]
  }
}

resource "huaweicloud_cbr_vault" "server_vault" {
  name             = "${var.cbr_server_vault_name}"
  size             = "${var.cbr_server_vault_size}"
  type             = "server"
  protection_type  = "backup"
  consistent_level = "crash_consistent"
  auto_expand      = true
  charging_mode    = "postPaid"
  policy_id        = "${huaweicloud_cbr_policy.cbr_server_policy.id}"

  resources {
    server_id = "${data.huaweicloud_compute_instance.ecs_generic_instance.id}"
  }
}
