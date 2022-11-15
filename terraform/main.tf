terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

resource "azurerm_resource_group" "votingapp" {
  name     = "votingapp"
  location = "West Europe"
}

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
  name                = "votingapp-aks"
  location            = azurerm_resource_group.votingapp.location
  resource_group_name = azurerm_resource_group.votingapp.name
  http_application_routing_enabled = true
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}



