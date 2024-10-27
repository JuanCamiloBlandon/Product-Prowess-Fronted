terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
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


resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = "echo Iniciando sesión en ACR... && az acr login --name ${data.azurerm_container_registry.existing.name} && echo Etiquetando la imagen Docker... && docker tag product-prowess-frontend ${data.azurerm_container_registry.existing.login_server}/product-prowess-frontend && echo Haciendo push de la imagen Docker... && docker push ${data.azurerm_container_registry.existing.login_server}/product-prowess-frontend"
  }
  depends_on = [data.azurerm_container_registry.existing]
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

  depends_on = [null_resource.docker_push,data.azurerm_container_registry.existing]

}

