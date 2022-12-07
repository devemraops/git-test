variable "env" {
    description = "the name environment for tags for cluster"
    validation {
        condition = var.env == "qa" || var.env == "ops" || var.env == "staging" || var.env == "live"
        error_message = "The environment was not recognized. Use qa||ops||staging||live"
    }
    type = string
} 

variable "application" {
    description = "Name of the application that will be used in all resources names"
    type = string
}

variable "region" {}
variable "cluster_version" {}
# variable "cluster_name" {}
variable "capacity_type" {}
variable "max_size" {}
variable "desired_size" {}
variable "min_size" {}
variable "ami_type" {}
variable "disk_size" {}
variable "instance_type" {}
variable "eks_role_name" {}
variable "service" {}
variable "eks_worker_role_name" {}
variable "node_group_name" {}