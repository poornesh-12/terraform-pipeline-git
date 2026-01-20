resource "azurerm_resource_group" "poorneshtf" {
  location = var.location
  name     = var.rg_name
}

resource "azurerm_virtual_network" "vname" {
  name                = var.vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.poorneshtf.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.poorneshtf.name
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vname
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsgname
  location            = azurerm_resource_group.poorneshtf.location
  resource_group_name = azurerm_resource_group.poorneshtf.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.nicname
  location            = azurerm_resource_group.poorneshtf.location
  resource_group_name = azurerm_resource_group.poorneshtf.name

  ip_configuration {
    name                          = "internal"
    subnet_id                    = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vmlinux" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.poorneshtf.name
  location            = azurerm_resource_group.poorneshtf.location
  size                = "Standard_D2s_v5"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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


