terraform {
  required_providers {
    azurerm = {
        version = ">3.0"
        source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    storage_account_name = "netflixterraformsa"
    container_name = "tfstatefiles"
    resource_group_name = "terraformstatersg"
    key = "k8s.tfstate"
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

resource "azurerm_container_registry" "acr" {
  name = var.acr_name
  location = var.location
  resource_group_name = azurerm_resource_group.rsg.name
  sku = "Premium"
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = var.cluster_name
    resource_group_name = azurerm_resource_group.rsg.name
    location = var.location
    dns_prefix = var.dns_prefix

    default_node_pool {
        name = "devpool"
        vm_size = "Standard_D2_v3"
        node_count = 1
    }
    node_provisioning_profile {
        mode = "Manual"
    }
    identity {
        type = "SystemAssigned"
    }
    tags = {
      Environment = "Development"
    }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id = azurerm_container_registry.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}