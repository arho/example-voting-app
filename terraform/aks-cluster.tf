resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "votingapplogs" {
  location            = azurerm_resource_group.votingapp.location
  name                = "votingapp-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = azurerm_resource_group.votingapp.name
}

resource "azurerm_log_analytics_solution" "votingapplogscontainers" {
  location              = azurerm_log_analytics_workspace.votingapplogs.location
  resource_group_name   = azurerm_resource_group.votingapp.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.votingapplogs.name
  workspace_resource_id = azurerm_log_analytics_workspace.votingapplogs.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "votingapp" {
  name                             = "votingapp-aks"
  location                         = azurerm_resource_group.votingapp.location
  resource_group_name              = azurerm_resource_group.votingapp.name
  http_application_routing_enabled = true
  dns_prefix                       = "votingapp"
  network_profile {
    service_cidr       = "10.0.10.0/24"
    network_plugin     = "azure"
    dns_service_ip     = "10.0.10.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks-subnet.id
  }
  identity {
    type = "SystemAssigned"
  }
}
