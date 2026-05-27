output "app_node_ip" {
  value       = docker_container.app_node.network_data[0].ip_address
  description = "IP address of the Application Node"
}

output "monitor_node_ip" {
  value       = docker_container.monitor_node.network_data[0].ip_address
  description = "IP address of the Monitoring Node"
}
