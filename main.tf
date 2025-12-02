# Define the resource group
resource "azurerm_resource_group" "aks" {
  name     = "aks-rg"
  location = "eastus"
}  

resource "azurerm_resource_group" "winvm" {
  name     = "winvm-rg"
  location = "eastus"
}


# Define the resource group
resource "azurerm_resource_group" "endusers" {
  name     = "endusers-rg"
  location = "WestUS"
}



