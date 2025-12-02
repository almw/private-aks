# Define the private AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aksalmwdemocluster101"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "aksalmwdemocluster101"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"

    vnet_subnet_id = azurerm_subnet.aks.id
  }

  private_cluster_enabled = true

  private_dns_zone_id = azurerm_private_dns_zone.aks.id

# Attach the identity to the AKS cluster
  identity {
    type = "UserAssigned"
    identity_ids  = [azurerm_user_assigned_identity.aks_uami.id]
  }
  tags = {
    environment = "production"
  }
}
