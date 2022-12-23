terraform {
    backend "azurerm" {
        storage_account_name = "nurgul"                  # Use your own unique name here
        container_name       = "terraform-sample"        # Use your own container name here
        key                  = "terraform.tfstate"       # Add a name to the state file
        resource_group_name  = "nurrg"                   # Use your own resource group name here
    }
}
