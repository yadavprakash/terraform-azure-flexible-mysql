output "flexible-mysql_server_id" {
  value       = module.flexible-mysql-replication.mysql_flexible_server_id
  description = "The ID of the MySQL Flexible Server."
}
output "azurerm_private_dns_zone_virtual_network_link2_id" {
  value       = module.flexible-mysql-replication.existing_private_dns_zone_virtual_network_link_id
  description = "The ID of the Private DNS Zone Virtual Network Link."
}
output "azurerm_flexible-mysql_server_configuration_id" {
  value       = module.flexible-mysql-replication.azurerm_mysql_flexible_server_configuration_id
  description = "The ID of the MySQL Flexible Server Configuration."
}





