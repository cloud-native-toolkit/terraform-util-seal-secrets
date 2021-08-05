output "dest_dir" {
  description = "The destination directory for the sealed secrets"
  value       = var.dest_dir
  depends_on  = [null_resource.seal_secrets]
}

variable "sealed_secrets" {
  description = "List of secret files that were sealed by the cert"
  value       = local.sealed_secrets
  depends_on  = [null_resource.seal_secrets]
}
