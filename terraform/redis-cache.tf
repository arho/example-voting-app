resource "random_integer" "redis-cache-tail" {
  min = 10000
  max = 99999
}


resource "azurerm_redis_cache" "redis-cache" {
  name                          = "votingapp-redis-${random_integer.redis-cache-tail.result}"
  location                      = azurerm_resource_group.votingapp.location
  resource_group_name           = azurerm_resource_group.votingapp.name
  capacity                      = 1
  family                        = "P"
  sku_name                      = "Premium"
  redis_version                 = 6
  subnet_id                     = azurerm_subnet.redis-cache-subnet.id
  public_network_access_enabled = false
  enable_non_ssl_port           = true
  private_static_ip_address     = "10.0.1.25"
  redis_configuration {
    enable_authentication = false
  }
}

