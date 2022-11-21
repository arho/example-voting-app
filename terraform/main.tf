terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf-backend"
    storage_account_name = "ccaztfmainback3352bdbe2"
    container_name       = "tfbackends"
    key                  = "votingapp.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "votingapp" {
  name     = var.appname
  location = var.location
}







