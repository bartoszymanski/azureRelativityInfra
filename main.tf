resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_resource_group" "projekt_rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_mssql_server" "server_sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.projekt_rg.name
  location                     = azurerm_resource_group.projekt_rg.location
  version                      = var.sql_version
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_firewall_rule" "firewall_sql" {
  name             = var.sql_firewall_name
  server_id        = azurerm_mssql_server.server_sql.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_database" "database_sql" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.server_sql.id
  collation      = var.db_collation
  max_size_gb    = var.db_size
  sku_name       = "Basic"
  storage_account_type = "Local"
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.app_service_plan}-${random_integer.ri.result}"
  location            = azurerm_resource_group.projekt_rg.location
  resource_group_name = azurerm_resource_group.projekt_rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.web_app_name
  location            = azurerm_resource_group.projekt_rg.location
  resource_group_name = azurerm_resource_group.projekt_rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  depends_on            = [azurerm_service_plan.appserviceplan]
  https_only            = true
  site_config {
    linux_fx_version = "PYTHON|3.10"
  }

  app_settings = {
    DB_HOST     = azurerm_mysql_flexible_server.db_instance.fully_qualified_domain_name
    DB_NAME     = azurerm_mysql_flexible_server_database.db.name
    DB_USER     = var.sql_admin_username
    DB_PASS     = var.sql_admin_password
    SECRET_KEY  = var.flask_secret_key
    SENDGRID_API_KEY = var.sendgrid_api_key
    SENDGRID_EMAIL = var.sendgrid_email
  }
}

resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/bartoszymanski/azureRelativity"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}

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
