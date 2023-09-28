### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
}


resource "huaweicloud_smn_topic" "topic_alarm" {
  name         = "${var.app_name}-${var.environment}-topic-alarm"
  display_name = "${var.app_name}-${var.environment}-topic-alarm"
}

resource "huaweicloud_smn_subscription" "subscription_email" {
  topic_urn = huaweicloud_smn_topic.topic_alarm.id
  endpoint  = "${var.alarm_email_address}"
  protocol  = "email"
  remark    = "O&M"
}
