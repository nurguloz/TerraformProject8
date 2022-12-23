output "frontend_id" {
  value = "${azurerm_subnet.my_subnet_frontend.id}"
}

output "backend_id" {
  value = "${azurerm_subnet.my_subnet_backend.id}"
}

output "dmz_id" {
  value = "${azurerm_subnet.my_subnet_dmz.id}"
}

output "load_balancer_ip" {
  value = "${azurerm_public_ip.frontend.ip_address}"
}
