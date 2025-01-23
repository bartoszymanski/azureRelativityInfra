resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_resource_group" "projekt_rg" {
  name     = var.resource_group
  location = var.location
}
resource "azurerm_log_analytics_workspace" "example" {
  name                = "workspace-relativity"
  location            = azurerm_resource_group.projekt_rg.location
  resource_group_name = azurerm_resource_group.projekt_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "example" {
  name                = "relativity-appinsights"
  location            = azurerm_resource_group.projekt_rg.location
  resource_group_name = azurerm_resource_group.projekt_rg.name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"
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
  name                = var.sql_firewall_name
  server_id           = azurerm_mssql_server.server_sql.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_database" "database_sql" {
  name                 = var.database_name
  server_id            = azurerm_mssql_server.server_sql.id
  collation            = var.db_collation
  max_size_gb          = var.db_size
  sku_name             = "Basic"
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
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  depends_on          = [azurerm_service_plan.appserviceplan]
  https_only          = true
  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    DB_URI                          = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:${azurerm_mssql_server.server_sql.fully_qualified_domain_name},1433;Database=${var.database_name};Uid=${var.sql_admin_username};Pwd=${var.sql_admin_password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    DB_USER                         = var.sql_admin_username
    DB_PASS                         = var.sql_admin_password
    SECRET_KEY                      = var.flask_secret_key
    APPINSIGHTS_INSTRUMENTATION_KEY = azurerm_application_insights.example.instrumentation_key
  }
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.projekt_rg.name
  location                 = azurerm_resource_group.projekt_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "example" {
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.projekt_rg.name
  location            = azurerm_resource_group.projekt_rg.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.appserviceplan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
  app_settings = {
    DB_URI                          = "Driver={ODBC Driver 17 for SQL Server};Server=tcp:${azurerm_mssql_server.server_sql.fully_qualified_domain_name},1433;Database=${var.database_name};Uid=${var.sql_admin_username};Pwd=${var.sql_admin_password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    APPINSIGHTS_INSTRUMENTATION_KEY = azurerm_application_insights.example.instrumentation_key
    SENDGRID_API_KEY                = var.sendgrid_api_key
    SENDGRID_EMAIL                  = var.sendgrid_email
    COSMOS_KEY                      = "Nvntl4QZQlEAEC88Dl8hnUaC1dGlD5p80mDRxIWg1DkD1ZR4OsZuL9PsLzyLcNxlYBGCVL1RiOzTACDbFqveRg=="
    COSMOS_ENDPOINT                 = "xd"
    COSMOS_DATABASE                 = "xd"
    COSMOS_CONTAINER                = "xd"
  }
}