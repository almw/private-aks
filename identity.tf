#User-Assigned Managed Identity to AKS
resource "azurerm_user_assigned_identity" "aks_uami" {
  name                = "aks-uami"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
}
# identity access to the Private DNS Zone
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_uami.principal_id
}
resource "azurerm_role_assignment" "aks_vnet_access" {
  scope                = azurerm_virtual_network.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_uami.principal_id
}
