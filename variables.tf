variable "subscription_id" {
  description = "ID of the Azure subscription"
  type        = string
}

variable "resource_group" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region/location"
  type        = string
}

variable "app_service_plan" {
  description = "Name of the Azure App Service Plan"
  type        = string
}

variable "web_app_name" {
  description = "Name of the Azure Web App"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server instance"
  type        = string
}

variable "database_name" {
  description = "Name of the Azure SQL Database"
  type        = string
}

variable "sql_admin_password" {
  description = "Password for the Azure SQL admin user"
  type        = string
}

variable "sql_admin_username" {
  description = "Username for the Azure SQL admin user"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string
}

variable "function_code_path" {
  description = "Path to the function app code"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API Key for email notifications"
  type        = string
}

variable "sendgrid_email" {
  description = "SendGrid Email address"
  type        = string
}

variable "flask_secret_key" {
  description = "Secret key for the Flask app"
  type        = string
}

variable "endpoints" {
  type        = list(string)
  description = "List of API endpoints"
}
