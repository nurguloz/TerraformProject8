resource "azurerm_availability_set" "frontend" {
  name                         = "tf-avail-set"
  location                     = azurerm_resource_group.terraform_sample.location
  resource_group_name          = azurerm_resource_group.terraform_sample.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 20
  managed                      = true
  tags = {
    environment = "Production"
  }
}

resource "azurerm_storage_container" "frontend" {
  count                 = var.arm_frontend_instances
  name                  = "tf-storage-container-${count.index}"
  storage_account_name  = azurerm_storage_account.frontend.name
  container_access_type = "private"
}

resource "azurerm_network_interface" "frontend" {
  count               = var.arm_frontend_instances
  name                = "tf-interface-${count.index}"
  location            = azurerm_resource_group.terraform_sample.location
  resource_group_name = azurerm_resource_group.terraform_sample.name

  ip_configuration {
    name                          = "tf-ip-${count.index}"
    subnet_id                     = azurerm_subnet.my_subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "frontend" {
  count                 = var.arm_frontend_instances
  name                  = "tf-instance-${count.index}"
  location              = azurerm_resource_group.terraform_sample.location
  resource_group_name   = azurerm_resource_group.terraform_sample.name
  network_interface_ids = ["${element(azurerm_network_interface.frontend.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"
  availability_set_id   = azurerm_availability_set.frontend.id

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "tf-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "tf-datadisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "1023"
    create_option     = "Empty"
    lun               = 0
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "tf-instance-${count.index}"
    admin_username = "demo"
    admin_password = var.arm_vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

