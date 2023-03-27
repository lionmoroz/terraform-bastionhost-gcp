output "ip_bastion" {

  value = google_compute_instance.bastion_vm.network_interface.0.network_ip
  description = "Bastion ip address"

}
output "ip_nginx" {

  value = google_compute_instance.nginx_vm.network_interface.0.network_ip
  description = "The nginx ip address"

}