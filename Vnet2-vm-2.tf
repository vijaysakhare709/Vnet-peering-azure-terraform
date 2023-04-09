

# creating virtual network (Vnet) 

resource "azurerm_virtual_network" "virtualnetwork-2" {
  name                = "vnet-2"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${azurerm_resource_group.vijay.location}"
  address_space       = ["10.1.0.0/16"]

  tags = {
    environement = "dev"
  }
}

# Creating multipal subnet in vnet (type = list)

resource "azurerm_subnet" "virtualsubnet-2" {
  name                 =  "vnet1-subnet-2"
  resource_group_name  = "${azurerm_resource_group.vijay.name}"
  virtual_network_name = "${azurerm_virtual_network.virtualnetwork-2.name}"
  address_prefixes     = ["10.1.0.0/24"]

}

resource "azurerm_network_security_group" "vijay-nsg-2" {
  name                = "vnet2-nsg"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${azurerm_resource_group.vijay.location}"
  

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "vijay-nsg-rule-2" {
  name                        = "vnet2-nsg-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.vijay.name}"
  network_security_group_name = "${azurerm_network_security_group.vijay-nsg-2.name}"
}

resource "azurerm_subnet_network_security_group_association" "vijay-assocation2" {
  subnet_id                 = "${azurerm_subnet.virtualsubnet-2.id}"
  network_security_group_id = "${azurerm_network_security_group.vijay-nsg-2.id}"
}


resource "azurerm_public_ip" "public-ip-2" {
  name                = "vnet2-public-ip-2"
  resource_group_name = "${azurerm_resource_group.vijay.name}"
  location            = "${azurerm_resource_group.vijay.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}


resource "azurerm_network_interface" "vijay-interfaced-2" {
  name                = "vnet1-interface-2"
  location            = "${azurerm_resource_group.vijay.location}"
  resource_group_name = "${azurerm_resource_group.vijay.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.virtualsubnet-2.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public-ip-2.id}"
  }
  tags = {
    environment = "dev"
  }

}

resource "azurerm_linux_virtual_machine" "vijhellaymahcine-2" {
  name                  = "vnet2-vm-2"
  resource_group_name   = "${azurerm_resource_group.vijay.name}"
  location              = "${azurerm_resource_group.vijay.location}"
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.vijay-interfaced-2.id]

  custom_data = filebase64("customdata.tpl")


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/vijaykey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }

}
