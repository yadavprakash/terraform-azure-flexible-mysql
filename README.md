# terraform-azure-flexible-mysql

# Terraform Azure Infrastructure

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Author](#author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This repository contains Terraform code to deploy resources on Microsoft Azure, including a resource group and a virtual network and flexible-mysql.


## Usage
To use this module, you should have Terraform installed and configured for AZURE. This module provides the necessary Terraform configuration
for creating AZURE resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples

# Example: flexible-mysql

```hcl
module "flexible-mysql" {
  depends_on          = [module.resource_group, module.vnet]
  source              = "git::https://github.com/yadavprakash/terraform-azure-flexible-mysql.git?ref=v1.0.0"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  virtual_network_id  = module.vnet.id
  delegated_subnet_id = [module.subnet.default_subnet_id][0]
  mysql_version       = "8.0.21"
  private_dns         = true
  zone                = "1"
  admin_username      = "mysqlusername"
  admin_password      = "ba5yatgfgfhdsv6A3ns2lu4gqzzc"
  sku_name            = "GP_Standard_D8ds_v4"
  db_name             = "maindb"
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
  auto_grow_enabled   = true
  iops                = 360
  size_gb             = "20"
  #azurerm_mysql_flexible_server_configuration
  server_configuration_names = ["interactive_timeout", "audit_log_enabled"]
  values                     = ["600", "ON"]
}
```

# Example: flexible-mysql-replication
```hcl
module "flexible-mysql-replication" {
  depends_on                     = [module.resource_group, module.vnet, data.azurerm_resource_group.main]
  source                         = "git::https://github.com/yadavprakash/terraform-azure-flexible-mysql.git?ref=v1.0.0"
  name                           = local.name
  environment                    = local.environment
  main_rg_name                   = data.azurerm_resource_group.main.name
  resource_group_name            = module.resource_group.resource_group_name
  location                       = module.resource_group.resource_group_location
  virtual_network_id             = module.vnet.id
  delegated_subnet_id            = [module.subnet.default_subnet_id][0]
  mysql_version                  = "8.0.21"
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
```
This example demonstrates how to create various AZURE resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/yadavprakash/terraform-azure-flexible-mysql/tree/master/_example) directory within this repository.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/yadavprakash/terraform-azure-flexible-mysql/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0, < 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/yadavprakash/terraform-azure-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_flexible_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_server_key.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server_key) | resource |
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [random_password.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password associated with the admin\_username user | `string` | `null` | no |
| <a name="input_admin_password_length"></a> [admin\_password\_length](#input\_admin\_password\_length) | Length of random password generated. | `number` | `16` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The administrator login name for the new SQL Server | `any` | `null` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | Should Storage Auto Grow be enabled? Defaults to true. | `bool` | `false` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7 | `number` | `7` | no |
| <a name="input_charset"></a> [charset](#input\_charset) | Specifies the Charset for the MySQL Database, which needs to be a valid MySQL Charset. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | Specifies the Collation for the MySQL Database, which needs to be a valid MySQL Collation. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default` | `string` | `"Default"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Specifies the name of the MySQL Database, which needs to be a valid MySQL identifier. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | The resource ID of the subnet | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `bool` | `false` | no |
| <a name="input_existing_private_dns_zone_id"></a> [existing\_private\_dns\_zone\_id](#input\_existing\_private\_dns\_zone\_id) | n/a | `string` | `""` | no |
| <a name="input_existing_private_dns_zone_name"></a> [existing\_private\_dns\_zone\_name](#input\_existing\_private\_dns\_zone\_name) | The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Should geo redundant backup enabled? Defaults to false. Changing this forces a new MySQL Flexible Server to be created. | `bool` | `true` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability | <pre>object({<br>    mode                      = string<br>    standby_availability_zone = optional(number)<br>  })</pre> | <pre>{<br>  "mode": "SameZone",<br>  "standby_availability_zone": 1<br>}</pre> | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The storage IOPS for the MySQL Flexible Server. Possible values are between 360 and 20000. | `number` | `360` | no |
| <a name="input_key_vault_key_id"></a> [key\_vault\_key\_id](#input\_key\_vault\_key\_id) | The URL to a Key Vault Key | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the MySQL Flexible Server should exist. Changing this forces a new MySQL Flexible Server to be created. | `string` | `""` | no |
| <a name="input_main_rg_name"></a> [main\_rg\_name](#input\_main\_rg\_name) | n/a | `string` | `""` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'yadavprakash'. | `string` | `""` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created. | `string` | `"5.7"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_point_in_time_restore_time_in_utc"></a> [point\_in\_time\_restore\_time\_in\_utc](#input\_point\_in\_time\_restore\_time\_in\_utc) | The point in time to restore from creation\_source\_server\_id when create\_mode is PointInTimeRestore. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | n/a | `bool` | `false` | no |
| <a name="input_registration_enabled"></a> [registration\_enabled](#input\_registration\_enabled) | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled | `bool` | `false` | no |
| <a name="input_replication_role"></a> [replication\_role](#input\_replication\_role) | The replication role. Possible value is None. | `string` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `any` | `""` | no |
| <a name="input_server_configuration_names"></a> [server\_configuration\_names](#input\_server\_configuration\_names) | Specifies the name of the MySQL Flexible Server Configuration, which needs to be a valid MySQL configuration name. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_size_gb"></a> [size\_gb](#input\_size\_gb) | The max storage allowed for the MySQL Flexible Server. Possible values are between 20 and 16384. | `string` | `"20"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU Name for the MySQL Flexible Server. | `string` | `"GP_Standard_D8ds_v4"` | no |
| <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id) | The resource ID of the source MySQL Flexible Server to be restored. Required when create\_mode is PointInTimeRestore, GeoRestore, and Replica. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | Specifies the value of the MySQL Flexible Server Configuration. See the MySQL documentation for valid values. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The name of the virtual network | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_mysql_flexible_server_configuration_id"></a> [azurerm\_mysql\_flexible\_server\_configuration\_id](#output\_azurerm\_mysql\_flexible\_server\_configuration\_id) | The ID of the MySQL Flexible Server Configuration. |
| <a name="output_azurerm_private_dns_zone_id"></a> [azurerm\_private\_dns\_zone\_id](#output\_azurerm\_private\_dns\_zone\_id) | The Private DNS Zone ID. |
| <a name="output_azurerm_private_dns_zone_virtual_network_link_id"></a> [azurerm\_private\_dns\_zone\_virtual\_network\_link\_id](#output\_azurerm\_private\_dns\_zone\_virtual\_network\_link\_id) | The ID of the Private DNS Zone Virtual Network Link. |
| <a name="output_existing_private_dns_zone_virtual_network_link_id"></a> [existing\_private\_dns\_zone\_virtual\_network\_link\_id](#output\_existing\_private\_dns\_zone\_virtual\_network\_link\_id) | The ID of the Private DNS Zone Virtual Network Link. |
| <a name="output_mysql_flexible_server_id"></a> [mysql\_flexible\_server\_id](#output\_mysql\_flexible\_server\_id) | The ID of the MySQL Flexible Server. |
<!-- END_TF_DOCS -->