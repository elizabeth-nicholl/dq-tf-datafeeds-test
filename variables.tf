variable "data_feeds_cidr_block" {}
variable "peering_cidr_block" {}
variable "appsvpc_id" {}
variable "opssubnet_cidr_block" {}
variable "data_pipe_apps_cidr_block" {}
variable "data_feeds_cidr_block_az2" {}
variable "az" {}
variable "az2" {}

variable "datafeed_rds_db_name" {
  default = "ef_db"
}

variable "route_table_id" {
  default     = false
  description = "Value obtained from Apps module"
}
