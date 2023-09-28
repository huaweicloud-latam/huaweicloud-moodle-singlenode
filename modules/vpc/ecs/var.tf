## Region and Availability zone variables ##

variable "region" {
    default = ""
}

variable "availability_zone" {
    default = ""
}

## Network variables ##

variable "subnet_name" {
}

## Instance variables ## 

variable "app_name" {
    default = ""
}

variable "ecs_image_name" {
  default = ""
}

variable "ecs_image_type" {
  default = ""
}

variable "ecs_instance_type" {
  default = ""
}

variable "ecs_sysdisk_type" {
  default = ""
}

variable "ecs_sysdisk_size" {
  default = ""
}

variable "ecs_datadisk_type" {
  default = ""
}

variable "ecs_datadisk_size" {
  default = ""
}


variable "ecs_instance_id" {
  default = ""
}

variable "public_key_file" {
    default = ""
}


variable "environment" {
  default = ""
}

## Security Group variable ## 

variable "ports-ranges" {
  description = "Port ranges to create on security group rule"
  default = [""]
}

## Elastic IP variables ##

variable "ecs_attach_eip" {
  default = ""
}

variable "elb_attach_eip" {
  default = ""
}

variable "eip_bandwidth_size" {
  default = ""
}

variable "remote_exec_path" {
  default = ""
}

variable "remote_exec_filename" {
  default = ""
}

