provider "azurerm" {
  features {}
}

locals {
  name        = "appnewh"
  environment = "test"
  #label_order = ["name", "environment"]
}

module "resource_group" {
  source      = "git::https://github.com/yadavprakash/terraform-azure-resource-group.git?ref=v1.0.0"
  name        = "app"
  environment = "flexible"
  location    = "North Europe"
}


module "vnet" {
  source              = "git::https://github.com/yadavprakash/terraform-azure-vnet.git?ref=v1.0.0"
  name                = "app"
  environment         = "testnew"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

module "subnet" {
  source = "git::https://github.com/yadavprakash/terraform-azure-subnet.git?ref=v1.0.1"

  name                 = "app"
  environment          = "test"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet[*].vnet_name)

  #subnet
  subnet_names      = ["subnet1"]
  subnet_prefixes   = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]
  delegation = {
    flexibleServers_delegation = [
      {
        name    = "Microsoft.DBforMySQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }

  # route_table
  enable_route_table = true
  route_table_name   = "default_subnet"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}


data "azurerm_resource_group" "main" {
  name = "app-tested-resource-group"
}

data "azurerm_private_dns_zone" "main" {
  depends_on          = [data.azurerm_resource_group.main]
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.main.name
}


module "flexible-mysql-replication" {
  depends_on          = [module.resource_group, module.vnet, data.azurerm_resource_group.main]
  source              = "../../."
  name                = local.name
  environment         = local.environment
  main_rg_name        = data.azurerm_resource_group.main.name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  virtual_network_id  = module.vnet.vnet_id[0]
  delegated_subnet_id = module.subnet.subnet_id[0]
  mysql_version       = "8.0.21"
  #mysql_server_name              = "testmysqlserver"
  zone                           = "1"
  admin_username                 = "mysqlusern"
  admin_password                 = "ba5yatgfgfhdsvvc6A3ns2lu4gqzzc"
  sku_name                       = "GP_Standard_D8ds_v4"
  db_name                        = "maindb"
  charset                        = "utf8"
  collation                      = "utf8_unicode_ci"
  auto_grow_enabled              = true
  iops                           = 360
  size_gb                        = "20"
  existing_private_dns_zone      = true
  existing_private_dns_zone_id   = data.azurerm_private_dns_zone.main.id
  existing_private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  ##azurerm_mysql_flexible_server_configuration
  server_configuration_names = ["interactive_timeout", "audit_log_enabled"]
  values                     = ["600", "ON"]
}

