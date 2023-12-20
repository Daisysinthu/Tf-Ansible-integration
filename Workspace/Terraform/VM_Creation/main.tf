terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "dev-rg" {
  name     = "Dev-RG"
  location = "East US"
}

resource "azurerm_virtual_network" "dev-vnet" {
  name                = "Dev-vnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
}

resource "azurerm_subnet" "dev-snet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.dev-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "dev-nsg" {
    name                = "Dev-nsg"
    resource_group_name = azurerm_resource_group.dev-rg.name
    location            = azurerm_resource_group.dev-rg.location
    security_rule {
      name                       = "AllowSSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

resource "azurerm_network_interface" "dev-nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev-snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = azurerm_resource_group.dev-rg.location
  size                = "Standard_F2"
  disable_password_authentication = "false"
  admin_username      = "adminuser"
  admin_password      = "adminuser@1234567"
  network_interface_ids = [
    azurerm_network_interface.dev-nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}