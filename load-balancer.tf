resource "azurerm_public_ip" "frontend" {
    name                         = "tf-public-ip"
    location                     = "${azurerm_resource_group.terraform_sample.location}"
    resource_group_name          = "${azurerm_resource_group.terraform_sample.name}"
    allocation_method            = "Static"
}

resource "azurerm_lb" "frontend" {
    name                = "tf-lb"
    location            = "${azurerm_resource_group.terraform_sample.location}"
    resource_group_name = "${azurerm_resource_group.terraform_sample.name}"
    frontend_ip_configuration {
        name                          = "default"
        public_ip_address_id          = "${azurerm_public_ip.frontend.id}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_lb_probe" "port80" {
    name                = "tf-lb-probe-80"
    loadbalancer_id     = "${azurerm_lb.frontend.id}"
    protocol            = "Http"
    request_path        = "/"
    port                = 80
}

resource "azurerm_lb_rule" "port80" {
    name                    = "tf-lb-rule-80"
    loadbalancer_id         = "${azurerm_lb.frontend.id}"
    backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.frontend.id}"]
    probe_id                = "${azurerm_lb_probe.port80.id}"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "default"
}

resource "azurerm_lb_probe" "port443" {
    name                = "tf-lb-probe-443"
    loadbalancer_id     = "${azurerm_lb.frontend.id}"
    protocol            = "Http"
    request_path        = "/"
    port                = 443
}

resource "azurerm_lb_rule" "port443" {
    name                    = "tf-lb-rule-443"  
    loadbalancer_id         = "${azurerm_lb.frontend.id}"
    backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.frontend.id}"]
    probe_id                = "${azurerm_lb_probe.port443.id}"
    protocol                       = "Tcp"
    frontend_port                  = 443
    backend_port                   = 443
    frontend_ip_configuration_name = "default"
}

resource "azurerm_lb_backend_address_pool" "frontend" {
    name                = "tf-lb-pool"
    loadbalancer_id     = "${azurerm_lb.frontend.id}"
}
