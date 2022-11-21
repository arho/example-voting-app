resource "azurerm_network_security_group" "votingapp-nsg" {
  name                = "votingapp-nsg"
  location            = azurerm_resource_group.votingapp.location
  resource_group_name = azurerm_resource_group.votingapp.name
}

resource "azurerm_virtual_network" "votingapp-vnet" {
  name                = "votingapp-vnet"
  location            = azurerm_resource_group.votingapp.location
  resource_group_name = azurerm_resource_group.votingapp.name
  address_space       = ["10.0.0.0/16", "10.10.0.0/16"]
  tags = {
    app = "VotingApp"
  }
}

# Redis Cache Subnet
resource "azurerm_subnet" "redis-cache-subnet" {
  name                 = "rediscache"
  resource_group_name  = azurerm_resource_group.votingapp.name
  virtual_network_name = azurerm_virtual_network.votingapp-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "redis-cache-rules" {
  subnet_id                 = azurerm_subnet.redis-cache-subnet.id
  network_security_group_id = azurerm_network_security_group.votingapp-nsg.id
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-cluster-subnet"
  resource_group_name  = azurerm_resource_group.votingapp.name
  virtual_network_name = azurerm_virtual_network.votingapp-vnet.name
  address_prefixes     = ["10.10.0.0/16"]
}

# resource "azurerm_subnet" "aks-service-subnet" {
#   name                 = "aks-cluster-service-subnet"
#   resource_group_name  = azurerm_resource_group.votingapp.name
#   virtual_network_name = azurerm_virtual_network.votingapp-vnet.name
#   address_prefixes     = ["10.0.10.0/24"]
# }