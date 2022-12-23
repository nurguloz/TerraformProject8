
resource "azurerm_subnet" "my_subnet_frontend" {
  name                 = "frontend"
  resource_group_name  = "${azurerm_resource_group.terraform_sample.name}"
  virtual_network_name = "${azurerm_virtual_network.my_vn.name}"
  address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "my_subnet_backend" {
  name                 = "backend"
  resource_group_name  = "${azurerm_resource_group.terraform_sample.name}"
  virtual_network_name = "${azurerm_virtual_network.my_vn.name}"
  address_prefixes      = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "my_subnet_dmz" {
  name                 = "dmz"
  resource_group_name  = "${azurerm_resource_group.terraform_sample.name}"
  virtual_network_name = "${azurerm_virtual_network.my_vn.name}"
  address_prefixes      = ["10.0.3.0/24"]
}