resource "azurerm_virtual_network_peering" "vnetpeering-1" {
  name                      = "vnetpeering-1"
  resource_group_name       = azurerm_resource_group.vijay.name
  virtual_network_name      = azurerm_virtual_network.virtualnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.virtualnetwork-2.id
}

resource "azurerm_virtual_network_peering" "vnetpeering-2" {
  name                      = "vnetpeering-2"
  resource_group_name       = azurerm_resource_group.vijay.name
  virtual_network_name      = azurerm_virtual_network.virtualnetwork-2.name
  remote_virtual_network_id = azurerm_virtual_network.virtualnetwork.id
}
