##################################################################################
# LOCALS
##################################################################################


locals {
  resource_group_name   = "${var.naming_prefix}-rg-${random_integer.name_suffix.result}"
  app_service_plan_name = "${var.naming_prefix}-asp-${random_integer.name_suffix.result}"
  app_service_name      = "${var.naming_prefix}-webapp-${random_integer.name_suffix.result}"
  mysql_server_name     = "${var.naming_prefix}-mysqlserver"
}

resource "random_integer" "name_suffix" {
  min = 10000
  max = 99999
}

##################################################################################
# APP SERVICE
##################################################################################

resource "azurerm_resource_group" "myshuttle_rg" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "myshuttle_asp" {
  name                = local.app_service_plan_name
  resource_group_name = azurerm_resource_group.myshuttle_rg.name
  location            = azurerm_resource_group.myshuttle_rg.location
  reserved            = true
  kind                = "linux"

  sku {
    tier     = var.asp_tier
    size     = var.asp_size
    capacity = var.capacity
  }
}

resource "azurerm_linux_web_app" "myshuttle-webapp" {
  name                = local.app_service_name
  resource_group_name = azurerm_resource_group.myshuttle_rg.name
  location            = azurerm_resource_group.myshuttle_rg.location
  service_plan_id     = azurerm_app_service_plan.myshuttle_asp.id

  site_config {
    always_on = true

    application_stack {
      java_server         = var.java_server
      java_server_version = var.java_server_version
      java_version        = var.java_version
    }

  }
  connection_string {
    name  = "Database"
    type  = "MySql"
    value = "jdbc:mysql://${azurerm_mysql_server.myshuttle_mysqlServer.name}.database.azure.com:3306/${azurerm_mysql_database.alm.name}?useSSL=true&requireSSL=false&autoReconnect=true&user=${var.administrator_login}&password=${var.administrator_login_password}"
  }

  depends_on = [azurerm_mysql_server.myshuttle_mysqlServer, azurerm_mysql_database.alm]

}

resource "azurerm_mysql_server" "myshuttle_mysqlServer" {
  name                = local.mysql_server_name
  resource_group_name = azurerm_resource_group.myshuttle_rg.name
  location            = azurerm_resource_group.myshuttle_rg.location

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name = "GP_Gen5_2"
  # storage_mb = 5120
  version = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_firewall_rule" "firewall_rule" {
  name                = "allow_access_to_azure_server"
  resource_group_name = azurerm_resource_group.myshuttle_rg.name
  server_name         = azurerm_mysql_server.myshuttle_mysqlServer.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [azurerm_mysql_server.myshuttle_mysqlServer]
}

resource "azurerm_mysql_database" "alm" {
  name                = "alm"
  resource_group_name = azurerm_resource_group.myshuttle_rg.name
  server_name         = azurerm_mysql_server.myshuttle_mysqlServer.name
  charset             = "utf8"
  collation           = "utf8_general_ci"

  depends_on = [azurerm_mysql_server.myshuttle_mysqlServer]

}


# resource "azurerm_application_insights" "Insights11" {
#   name                = "Insights11"
#   location            = azurerm_resource_group.rg_Java_appservices.location
#   resource_group_name = azurerm_resource_group.rg_Java_appservices.name
#   application_type    = "web"
#   workspace_id = azurerm_linux_web_app.new_Tommy_app.id
#   depends_on = [ azurerm_app_service_plan.java_splan ]
# }
