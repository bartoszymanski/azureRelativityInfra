# data "azurerm_role_definition" "cloudrun_noauth" {
#   name = "Azure Function Invoker"
# }

# data "azurerm_role_definition" "cloud_function_noauth" {
#   name = "Azure Function Invoker"
# }

# resource "azurerm_role_assignment" "cloudrun_noauth" {
#   scope              = azurerm_function_app.cloud_run_tf.id
#   role_definition_id = data.azurerm_role_definition.cloudrun_noauth.id
#   principal_id       = azurerm_user_assigned_identity.cloud_run_user_assigned.identity_principal_id
# }

# resource "azurerm_role_assignment" "cloud_function_noauth" {
#   scope              = azurerm_function_app.daily_email_function.id
#   role_definition_id = data.azurerm_role_definition.cloud_function_noauth.id
#   principal_id       = azurerm_user_assigned_identity.cloud_function_user_assigned.identity_principal_id
# }

# resource "azurerm_role_assignment" "cloud_run_sql_client" {
#   scope              = azurerm_sql_database.cloud_sql.id
#   role_definition_id = azurerm_builtin_role_definition.sql_server_contributor.id
#   principal_id       = var.project_principal_id
# }
