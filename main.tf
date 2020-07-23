# Resource Group
resource "azurerm_resource_group" "HVG-RG" {
    name     = upper("HVG-TERRAFORM-${var.prefix}-${var.region}-${var.env}")
    location = "${var.region}"
}

resource "azurerm_storage_account" "HVG-SA" {
  name                     = "hvgstorageaccount${var.region}"
  resource_group_name      = azurerm_resource_group.HVG-RG.name
  location                 = azurerm_resource_group.HVG-RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}"
  }
}

resource "azurerm_sql_server" "HVG-SQL" {
  name                         = "hvg-sql-server-${var.region}-${var.env}"
  resource_group_name          = azurerm_resource_group.HVG-RG.name
  location                     = azurerm_resource_group.HVG-RG.location
  version                      = "12.0"
  administrator_login          = "hvgadmin"
  administrator_login_password = "Pa55word!"

  # extended_auditing_policy {
  #   storage_endpoint                        = azurerm_storage_account.HVG-SA.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.HVG-SA.primary_access_key
  #   storage_account_access_key_is_secondary = true
  #   retention_in_days                       = 180
  # }

  # tags = {
  #   environment = "${var.env}"
  # }
}

resource "azurerm_sql_database" "HVG-DB" {
  name                = "dbTest"
  resource_group_name = azurerm_resource_group.HVG-RG.name
  location            = azurerm_resource_group.HVG-RG.location
  server_name         = azurerm_sql_server.HVG-SQL.name
  edition             ="Basic"
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.HVG-SA.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.HVG-SA.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 60
  }

  tags = {
    environment = "${var.env}"
  }
}
