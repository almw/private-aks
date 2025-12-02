# AKS Manager VM
resource "azurerm_network_security_group" "nsg_aksvm" {
  name                = "vm-nsgaksvm"
  location            = azurerm_resource_group.winvm.location
  resource_group_name = azurerm_resource_group.winvm.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "72.85.32.239/32"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pip_aksvm" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.winvm.location
  resource_group_name = azurerm_resource_group.winvm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Network Interface
resource "azurerm_network_interface" "nic_aksvm" {
  name                = "vm-nic"
  location            = azurerm_resource_group.winvm.location
  resource_group_name = azurerm_resource_group.winvm.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.bastion.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_aksvm.id
  }
}

# Attach nsgaksvm to NIC:
resource "azurerm_network_interface_security_group_association" "nic_aksvm" {
  network_interface_id      = azurerm_network_interface.nic_aksvm.id
  network_security_group_id = azurerm_network_security_group.nsg_aksvm.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm_aks" {
  name                  = "vm-aksmgr"
  resource_group_name   = azurerm_resource_group.winvm.name
  location              = azurerm_resource_group.winvm.location
  size                  = "Standard_DS2_v2"
  admin_username        = "dkuffar"
  admin_password        = "T0day@ssw0rd123!"   # store securely in Key Vault in production

  network_interface_ids = [
    azurerm_network_interface.nic_aksvm.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null   # managed storage
  }
}

# End User VM
resource "azurerm_network_security_group" "nsg_enduservm" {
  name                = "vm-enduser"
  location            = azurerm_resource_group.endusers.location
  resource_group_name = azurerm_resource_group.endusers.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.vm_nsg_source_address_prefix
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pip_endusers" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.endusers.location
  resource_group_name = azurerm_resource_group.endusers.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Network Interface
resource "azurerm_network_interface" "nic_endusers" {
  name                = "vm-nicendusers"
  location            = azurerm_resource_group.endusers.location
  resource_group_name = azurerm_resource_group.endusers.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.endusers.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_endusers.id
  }
}

# Attach nsgenduservm to nicendusers:
resource "azurerm_network_interface_security_group_association" "nicendusers_nsgenduservm" {
  network_interface_id      = azurerm_network_interface.nic_endusers.id
  network_security_group_id = azurerm_network_security_group.nsg_enduservm.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vmendusers" {
  name                  = "vm-endusers"
  resource_group_name   = azurerm_resource_group.endusers.name
  location              = azurerm_resource_group.endusers.location
  size                  = "Standard_DS2_v2"
  admin_username        = var.admin_username
  admin_password        = var.admin_password   # store securely in Key Vault in production

  network_interface_ids = [
    azurerm_network_interface.nic_endusers.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null   # managed storage
  }
}
