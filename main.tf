resource "azurerm_resource_group" "projekt_rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_mssql_server" "server_sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.projekt_rg.name
  location                     = azurerm_resource_group.projekt_rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "database_sql" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.server_sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = "Basic"
  storage_account_type = "Local"
}

# resource "azurerm_app_service" "web_app" {
#   name                = "example-flask-web-app"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

#   site_config {
#     linux_fx_version = "PYTHON|3.10"
#   }

#   app_settings = {
#     DB_HOST     = azurerm_mysql_flexible_server.db_instance.fully_qualified_domain_name
#     DB_NAME     = azurerm_mysql_flexible_server_database.db.name
#     DB_USER     = var.db_username
#     DB_PASS     = var.dbuser_pass
#     SECRET_KEY  = var.flask_secretkey
#     SENDGRID_API_KEY = var.SendGrid_API_Key
#     SENDGRID_EMAIL = var.SendGrid_Email
#   }
# }

# resource "azurerm_logic_app_workflow" "daily_email_job" {
#   name                = "example-daily-email-job"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   definition = <<DEFINITION
# {
#   "definition": {
#     "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
#     "actions": {
#       "Http": {
#         "inputs": {
#           "method": "GET",
#           "uri": "https://${azurerm_app_service.web_app.default_hostname}/trigger"
#         },
#         "runAfter": {}
#       }
#     },
#     "triggers": {
#       "Recurrence": {
#         "recurrence": {
#           "frequency": "Day",
#           "interval": 1
#         },
#         "type": "Recurrence"
#       }
#     }
#   },
#   "parameters": {}
# }
# DEFINITION
# }
