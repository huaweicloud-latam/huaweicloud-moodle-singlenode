### Provider Huawei Cloud and Credentials ## 
terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.38.0"
    }
  }
#  backend "s3" {
#    ## You should execute the command as below to declare the backend S3 AK and SK in OS ##
#    ## export AWS_ACCESS_KEY_ID="XXX"  ##
#    ## export AWS_SECRET_ACCESS_KEY="XXX" ##
#    bucket   = "l00324891-terraform-states"
#    key      = "mangement/terraform-states"
#    region   = "la-south-2"
#    endpoint = "obs.la-south-2.myhuaweicloud.com"
#
#    skip_region_validation      = true
#    skip_metadata_api_check     = true
#    skip_credentials_validation = true
#  }
}


provider "huaweicloud" {
  region      = "${var.region}"
  access_key  = "${var.ak}"
  secret_key  = "${var.sk}"
}


############### Declaring Module VPC Working ##################

module "vpc" {
  source              = "../modules/vpc/"
  region              = "${var.region}"
  vpc_name            = "${var.vpc_name}"
  vpc_cidr            = "${var.vpc_cidr}"
  subnet_name         = "${var.subnet_name}"
  subnet_cidr         = "${var.subnet_cidr}"
  subnet_gateway_ip   = "${var.subnet_gateway_ip}"  
  app_name            = "${var.app_name}"
  environment	      = "${var.environment}"
  ports-ranges        = "${var.ports-ranges}"
  remote_ip_prefix    = "${var.remote_ip_prefix}"
  dns_list            = "${var.dns_list}"
}


################# Declaring Module ECS Working ############### 

module "ecs" {
  source              = "../modules/ecs/"
  depends_on          = [module.vpc]
  region              = "${var.region}"
  availability_zone   = "${var.availability_zone1}"
  subnet_name         = "${var.subnet_name}"
  app_name            = "${var.app_name}"
  environment	      = "${var.environment}"
  ecs_image_name      = "${var.ecs_image_name}"
  ecs_image_type      = "${var.ecs_image_type}"
  ecs_instance_type   = "${var.ecs_instance_type}"
  ecs_sysdisk_type    = "${var.ecs_sysdisk_type}"
  ecs_sysdisk_size    = "${var.ecs_sysdisk_size}"
  ecs_datadisk_type   = "${var.ecs_datadisk_type}"
  ecs_datadisk_size   = "${var.ecs_datadisk_size}"
  public_key_file     = "${var.public_key_file}"
  ecs_attach_eip      = "${var.ecs_attach_eip}"
  eip_bandwidth_size  = "${var.eip_bandwidth_size}"
  remote_exec_path    = "${var.remote_exec_path}"
  remote_exec_filename= "${var.remote_exec_filename}"
}


################### Declaring Module CTS Working ############### 
module "cts" {
  source              = "../modules/cts/"
}
################### Declaring Module SMN Working ############### 
module "smn" {
  source              = "../modules/smn/"
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  alarm_email_address = "${var.alarm_email_address}"
}
################### Declaring Module CES Working ############### 
module "ces" {
  source              = "../modules/ces/"
  depends_on          = [module.smn]
  smn_topic_id        ="${module.smn.smn_topic_id}"
}
################### Declaring Module CBR Working ############### 
module "cbr" {
  source              = "../modules/cbr/"
  depends_on          = [module.ecs]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  cbr_server_policy   = "${var.cbr_server_policy}"
  cbr_server_vault_name = "${var.cbr_server_vault_name}"
  cbr_server_vault_size = "${var.cbr_server_vault_size}"
}
################### Declaring Module provisioner Working ############### 
module "provision" {
  source              = "../modules/provision/"
  depends_on          = [module.ecs]
  app_name            = "${var.app_name}"
  environment         = "${var.environment}"
  private_key_file    = "${var.private_key_file}"
  remote_exec_path    = "${var.remote_exec_path}"
  remote_exec_filename= "${var.remote_exec_filename}"
}
