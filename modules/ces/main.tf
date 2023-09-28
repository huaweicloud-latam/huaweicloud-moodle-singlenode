### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
}

#data "huaweicloud_smn_topic" "topic_alarm" {
#  name         = "${var.app_name}-${var.environment}-topic-alarm"
#}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_eip" {
  for_each = {
    blockEIP = "1"
    unblockEIP = "4"
    EIPBandwidthOverflow = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"
  
  metric {
    namespace   = "SYS.EIP"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }


}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_ecs" {
  for_each = {
    startAutoRecovery               = "2"
    endAutoRecovery                 = "2"
    faultAutoRecovery               = "1"
    vmIsRunningImproperly           = "2"
    VMFaultsByHostProcessExceptions = "2"
    RestartGuestOS                  = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.ECS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }

}

resource "huaweicloud_ces_alarmrule" "alarm_rule_event_rds" {
  for_each = {
    DatabaseProcessRestarted         = "1"
    instanceDiskFull                 = "1"
    fullBackupFailed                 = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.RDS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }

}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_dcs" {
  for_each = {
    redisNodeStatusAbnormal         = "2"
    memcachedInstanceStatusAbnormal = "2"
    instanceNodeAbnormalRestart     = "2"
    instanceBackupFailure           = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.DCS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }
}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_cbr" {
  for_each = {
    backupFailed                  = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.CBR"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }
}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_bms" {
  for_each = {
    DatabaseProcessRestarted             = "1"
    instanceDiskFull                     = "1"
    fullBackupFailed                     = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.BMS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }
}


resource "huaweicloud_ces_alarmrule" "alarm_rule_event_obs" {
  for_each = {
    deleteBucket              = "2"
  }

  alarm_name           = each.key
  alarm_level          = each.value
  alarm_action_enabled = false
  alarm_type           = "EVENT.SYS"

  metric {
    namespace   = "SYS.OBS"
    metric_name = each.key
  }

  condition  {
    period              = 0
    filter              = "average"
    comparison_operator = ">="
    value               = 1
    count               = 1
  }
# SMN doesn't support Data function, we have submmitted the requirement to Terraform provider team#
#  alarm_actions {
#    type              = "notification"
#    notification_list = [data.huaweicloud_smn_topic.topic_alarm.id]
#  }

  alarm_actions {
    type              = "notification"
    notification_list = [var.smn_topic_id]
  }
}

