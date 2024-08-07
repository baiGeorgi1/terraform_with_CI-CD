variable "resource_group_name" {
  type        = string
  description = "TaskBoard"

}
variable "resource_group_location" {
  type        = string
  description = "Resource group in Azure"

}
variable "service_plan_name" {
  type        = string
  description = "Name of the service plan"
}
variable "app_service_name" {
  type        = string
  description = "Name of the app"
}
variable "sql_server_name" {
  type        = string
  description = "Name of the SQL server"
}
variable "sql_database_name" {
  type        = string
  description = "Name of the DB"
}
variable "sql_admin_login" {
  type        = string
  description = "Name of the admin"
}
variable "sql_admin_password" {
  type        = string
  description = "Admin password"
}
variable "firewall_rule_name" {
  type        = string
  description = "Name of the firewall"
}
variable "repo_URL" {
  type        = string
  description = "Name of the repo"
}