## Credentials received from terraform.tfvars file

variable "ak" {}
variable "sk" {}

## Region and Availability zone variables ##

variable "region" {
#    default = "la-south-2"
#    default = "sa-brazil-1"
#    default = "na-mexico-1"
    default = "la-north-2"
}

variable "availability_zone1" {
#    default = "la-south-2a"
#    default = "sa-brazil-1a"
#    default = "na-mexico-1a"
    default = "la-north-2a"
}

variable "availability_zone2" {
#    default = "la-south-2b"
#    default = "sa-brazil-1b"
#    default = "na-mexico-1a"
    default = "la-north-2a"
}

## Network variables ##

variable "vpc_name" {
    default = "vpc_moodle"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "subnet_name" {
    default = "subnet_moodle"
}

variable "subnet_cidr" {
    default = "10.10.1.0/24"
}

variable "subnet_gateway_ip" {
    default = "10.10.1.1"
}

variable "dns_list" {
    default = ["100.125.1.250","100.125.1.242"]
}

## Application Environment variables ## 
variable "app_name" {
    default = "moodle"
}

variable "environment" {
  default = "production"
}


## ECS Instance variables ## 

variable "ecs_image_name" {
  default = "Debian 10.0.0 64bit"
}

variable "ecs_image_type" {
  default = "public"
}

variable "ecs_instance_type" {
  default = "s6.medium.2"
}

variable "ecs_sysdisk_type" {
  default = "GPSSD"
}

variable "ecs_sysdisk_size" {
  default = "40"
}

variable "ecs_datadisk_type" {
  default = "GPSSD"
}

variable "ecs_datadisk_size" {
  default = "100"
}

## SSH PUBLIC KEY ##
variable "public_key_file" {
## Place the key in terraform_root_path  entry/ ##
    default = "id_rsa.pub"
}


## Security Group variable ## 

variable "ports-ranges" {
  default = ["80" , "443"]
}

variable "remote_ip_prefix" {
  default = "0.0.0.0/0"
}

## Elastic IP variables ##

variable "ecs_attach_eip" {
  default = true
}

variable "eip_bandwidth_size" {
  default = "50"
}

## CBR variable ##
variable "cbr_server_policy" {
    default = "server-bk-policy"
}

variable "cbr_server_vault_name" {
    default = "server-bk-vault"
}

variable "cbr_server_vault_size" {
    default = "100"
}

## SMN variable ##
variable "alarm_email_address" {
    default = "shaowei.liu@huawei.com"
}

## Provsion variable ##

variable "private_key_file" {
## Place the key in terraform_root_path  entry/ ##
  default = "id_rsa"
}

variable "remote_exec_path" {
##  PATH /tmp ##
  default = "/tmp"
}
variable "remote_exec_filename" {
## Place the key in terraform_root_path  entry/ ##
  default = "auto-installation-scripts.sh"
}

