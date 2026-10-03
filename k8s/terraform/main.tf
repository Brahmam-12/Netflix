terraform {
  required_providers {
    azurerm = {
        version = ">3.0"
        source = "hashicorp/azurerm"
    }
  }
  required_version = ">=1.0"
}

provider "azurerm" {
    features {
      
    }
}

resource "azurerm_resource_group" "rsg" {
  name = var.rsg
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = var.cluster_name
    resource_group_name = azurerm_resource_group.rsg.name
    location = var.location
    dns_prefix = var.dns_prefix

    default_node_pool {
        name = "devpool"
        vm_size = "Standard_D2s_v5"
        node_count = 1
    }
    identity {
        type = "SystemAssigned"
    }
    tags = {
      Environment = "Development"
    }
}