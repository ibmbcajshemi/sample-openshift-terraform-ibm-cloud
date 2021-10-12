variable "region" {
    default = "us-south"
}

variable "generation" {
    default = 2
}

variable "environment" {
    default = "nonprod"
}



variable "schematics_workspace_id" {
    description = "The id of this schematics workspace.  Used to tag resources."
}

variable "schematics_workspace_name" {
    description = "The name of this schematics workspace.  Used to tag resources."
}

variable "vpc_name" {
    default = "cpd-dallas"
}

variable "vpc_resource_group" {
    description = "The name of the resource group for the VPC"
}

variable address_prefix_1 {
    default = "10.88.0.0/23"
}

variable address_prefix_2 {
    default = "10.88.8.0/23"
}

variable address_prefix_3 {
    default = "10.88.16.0/23"
}

variable app_cidr_block_1 {
    default = "10.88.0.0/28"
}

variable app_cidr_block_2 {
    default = "10.88.8.0/28"
}

variable app_cidr_block_3 {
    default = "10.88.16.0/28"
}

variable infra_cidr_block_1 {
    default = "10.88.0.16/28"
}

variable infra_cidr_block_2 {
    default = "10.88.8.16/28"
}

variable infra_cidr_block_3 {
    default = "10.88.16.16/28"
}


variable storage_cidr_block_1 {
    default = "10.88.0.32/28"
}

variable storage_cidr_block_2 {
    default = "10.88.8.32/28"
}

variable storage_cidr_block_3 {
    default = "10.88.16.32/28"
}


variable cp_cidr_block_1 {
    default = "10.88.0.48/28"
}

variable cp_cidr_block_2 {
    default = "10.88.8.48/28"
}

variable cp_cidr_block_3 {
    default = "10.88.16.48/28"
}


variable vpn_cidr_block_1 {
    default = "10.88.1.0/28"
}


##############################################################################
# Cluster Resources
##############################################################################
variable "cluster_name" {
  description = "The name of the OpenShift cluster"
}

variable "ocp_version" {
  description = "the version of OpenShift to be provisioned"
  default     = "4.6_openshift"
}

variable "default_pool_flavor" {
  description = "The worker node flavor for the default worker pool"
  default     = "bx2.4x16"
}

variable "default_pool_worker_count" {
  description = "The number of workers per zone in the default worker pool"
  default     = 1
}

variable "infrastructure_pool_flavor" {
  description = "The worker node flavor for the infrastructure worker pool"
  default     = "bx2.8x32"
}

variable "infrastructure_pool_worker_count" {
  description = "The number of workers per zone in the infrastructure worker pool"
  default     = 1
}

variable "storage_pool_flavor" {
  description = "The worker node flavor for the storage worker pool"
  default     = "bx2.16x64"
}

variable "storage_pool_worker_count" {
  description = "The number of workers per zone in the storage worker pool"
  default     = 1
}

variable "cloud_pak_pool_flavor" {
  description = "The worker node flavor for the cloud pak worker pool"
  default     = "bx2.32x128"
}

variable "cloud_pak_pool_worker_count" {
  description = "The number of workers per zone in the cloud pak worker pool"
  default     = 1
}