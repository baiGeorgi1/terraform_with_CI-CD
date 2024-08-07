terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.113.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "taskboardstoragegogo"
    container_name       = "taskboardcontainer"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
resource "random_integer" "RI" {
  min = 10000
  max = 99999

}

resource "azurerm_resource_group" "arg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
resource "azurerm_service_plan" "ASP" {
  name                = "TaskBoardServicePlan${random_integer.RI.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}
resource "azurerm_linux_web_app" "ALWA" {
  name                = "TaskBoardLinuxWebApp${random_integer.RI.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_service_plan.ASP.location
  service_plan_id     = azurerm_service_plan.ASP.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.SQLServerGogo.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.MSSQL_DB.name};User ID=${azurerm_mssql_server.SQLServerGogo.administrator_login};Password=${azurerm_mssql_server.SQLServerGogo.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"

  }
}
resource "azurerm_mssql_server" "SQLServerGogo" {
  name                         = "mssqlservergogo1234"
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"

}
resource "azurerm_mssql_database" "MSSQL_DB" {
  name           = "taskBoard-db"
  server_id      = azurerm_mssql_server.SQLServerGogo.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}
resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = "FirewallGogo"
  server_id        = azurerm_mssql_server.SQLServerGogo.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "github" {
  app_id   = azurerm_linux_web_app.ALWA.id
  repo_url = "https://github.com/baiGeorgi1/azure_webApp_with_DB"
  branch   = "main"
  #   Deploy the app manually when we use external GitHub Repo or s.e.
  use_manual_integration = true
}

