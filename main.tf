terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
  
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "existing" {
  name = "TerraformResourceGroup"
}


data "azurerm_container_registry" "existing" {
  name                = "acrterraformproductprowess"
  resource_group_name = data.azurerm_resource_group.existing.name
}

provider "docker" {
  registry_auth {
    address  = data.azurerm_container_registry.existing.login_server
    username = data.azurerm_container_registry.existing.admin_username
    password = data.azurerm_container_registry.existing.admin_password
  }
}

locals {
  image_name = "product-prowess-frontend:latest"
}

resource "docker_image" "init_app" {
  name = "${data.azurerm_container_registry.existing.login_server}/${local.image_name}"
  keep_locally = false
  
  build {
    no_cache = true
    context = "${path.cwd}"
  }
}

resource "docker_registry_image" "push_image_to_acr" {
  name          = docker_image.init_app.name
  keep_remotely = false
}


resource "azurerm_container_group" "aci" {
  name                = "mycontainerinstance" 
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  os_type             = "Linux"

  container {
    name   = "my-container"
    image  = "${data.azurerm_container_registry.existing.login_server}/product-prowess-frontend:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.existing.login_server
    username = data.azurerm_container_registry.existing.admin_username
    password = data.azurerm_container_registry.existing.admin_password
  }

  depends_on = [docker_registry_image.push_image_to_acr,data.azurerm_container_registry.existing]

}

