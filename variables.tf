variable "path_module" {
  default = "unset"
}

variable "naming_suffix" {
  default = "apps-test-dq"
}

variable "data_feeds_cidr_block" {
  default = "10.1.4.0/24"
}
variable "peering_cidr_block" {
  default = "10.3.0.0/16"
}
variable "appsvpc_id" {
  default = "10.1.0.0/16"
}
variable "opssubnet_cidr_block" {
  default = "10.8.0.0/16"
}
variable "data_pipe_apps_cidr_block" {
  default = "10.1.8.0/24"
}
variable "data_feeds_cidr_block_az2" {
  default = "10.1.5.0/24"
}
variable "az" {
  default = "a"
}
variable "az2" {
  default = "b"
}

variable "datafeed_rds_db_name" {
  default = "ef_db"
}

variable "route_table_id" {
  default     = false
  description = "Value obtained from Apps module"
}
