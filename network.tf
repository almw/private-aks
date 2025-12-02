# Define the AKS virtual network
resource "azurerm_virtual_network" "aks" {
  name                = "enduser-vnet"
  address_space       = ["172.16.0.0/24"]
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
}

# Define the subnet for AKS cluster
resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["172.16.0.0/26"]
  # rivate Link Service on AKS Subnet
  private_link_service_network_policies_enabled = false
}

# Define the subnet for the Azure Bastion (optional, for access to the private AKS cluster)
resource "azurerm_subnet" "bastion" {
  name                 = "bastion-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["172.16.0.64/26"]
}

# Define the End users virtual network
resource "azurerm_virtual_network" "endusers" {
  name                = "endusers-vnet"
  address_space       = ["192.168.0.0/24"]
  location            = azurerm_resource_group.endusers.location
  resource_group_name = azurerm_resource_group.endusers.name
}

# Define the subnet for EndUsers
resource "azurerm_subnet" "endusers" {
  name                 = "endusers-subnet"
  resource_group_name  = azurerm_resource_group.endusers.name
  virtual_network_name = azurerm_virtual_network.endusers.name
  address_prefixes     = ["192.168.0.0/26"]
}

resource "azurerm_subnet" "pep" {
  name                 = "pep-subnet"
  resource_group_name  = azurerm_resource_group.endusers.name
  virtual_network_name = azurerm_virtual_network.endusers.name
  address_prefixes     = ["192.168.0.64/26"]
}

# # # Create Private Link Service targeting the AKS IL
# resource "azurerm_private_link_service" "aks_pls" {
#   name                = "aks-pls"
#   location            = "eastus"
#   resource_group_name = "example-rg"

#   # Matches: "visibility": { "subscriptions": ["5670c878-..."] }

#   visibility_subscription_ids = [var.subscription_id]

#   # Matches: "autoApproval": { "subscriptions": [] }
#   auto_approval_subscription_ids = [var.subscription_id]

#   enable_proxy_protocol = false

#   # Matches: "loadBalancerFrontendIpConfigurations": [ { "id": "..." } ]
#   load_balancer_frontend_ip_configuration_ids = [
#     "/subscriptions/5670c878-c5f9-4979-93b8-68f58fb292ca/resourceGroups/MC_example-rg_aksalmwdemocluster101_eastus/providers/Microsoft.Network/loadBalancers/kubernetes/frontendIPConfigurations/053d13a2-eae4-4868-93bf-15fb0557f1aa"
#   ]

#   # Matches: "ipConfigurations": [ { "name": "aks-subnet-1", "subnet": {...}} ]
#   nat_ip_configuration {
#     name                       = "aks-subnet-1"
#     primary                    = true
#     private_ip_address_version = "IPv4"
#     # private_ip_allocation_method  = "Dynamic"
#     subnet_id = "/subscriptions/5670c878-c5f9-4979-93b8-68f58fb292ca/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/enduser-vnet/subnets/aks-subnet"
#   }
# }

# resource "azurerm_private_endpoint" "aks_pls_pep" {
#   name                = "aks-pls-pep"
#   location            = "westus"
#   resource_group_name = "endusers-rg"
#   subnet_id           = "/subscriptions/5670c878-c5f9-4979-93b8-68f58fb292ca/resourceGroups/endusers-rg/providers/Microsoft.Network/virtualNetworks/endusers-vnet/subnets/pep-subnet"

#   custom_network_interface_name = "aks-pls-pep-nic"

#   private_service_connection {
#     name                           = "aks-pls-pep"
#     private_connection_resource_id = "/subscriptions/5670c878-c5f9-4979-93b8-68f58fb292ca/resourceGroups/example-rg/providers/Microsoft.Network/privateLinkServices/aks-pls"
#     is_manual_connection           = false
#   }
# }


