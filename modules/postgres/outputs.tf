output "database_host" {
  value = kubernetes_service.postgres.spec.0.cluster_ip
}

output "database_port" {
  value = var.database_port
}

output "database_name" {
  value = var.database_name
}

output "database_user" {
  value = var.database_user
}

output "database_password" {
  value = local.db_password
}