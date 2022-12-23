resource "azurerm_resource_group" "terraform_sample" {
    name     = "terraform-sample"
    location = "${var.arm_region}"
}

resource "azurerm_virtual_network" "my_vn" {
  name                = "tf-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.terraform_sample.location}"
  resource_group_name = "${azurerm_resource_group.terraform_sample.name}"
}
