# Output the private cluster API server URL
output "aks_api_server" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
   sensitive = true
}
