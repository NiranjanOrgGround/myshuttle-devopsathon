#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "eastus"
}

variable "naming_prefix" {
  type    = string
  default = "myshuttle"
}

variable "asp_tier" {
  type        = string
  description = "Tier for App Service Plan (Standard, PremiumV2)"
  default     = "Basic"
}

variable "asp_size" {
  type        = string
  description = "Size for App Service Plan (S2, P1v2)"
  default     = "B1"
}

variable "capacity" {
  type        = string
  description = "Number of instances for App Service Plan"
  default     = "1"
}

variable "java_server" {
  type    = string
  default = "TOMCAT"
}

variable "java_server_version" {
  type    = string
  default = "9.0"
}

variable "java_version" {
  type    = string
  default = "11"
}

variable "administrator_login" {
  type    = string
  default = "myshuttle"
}

variable "administrator_login_password" {
  type    = string
  default = "P@ssw0rd@123"
}