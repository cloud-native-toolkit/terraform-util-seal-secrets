output "dest_dir" {
  description = "The destination directory for the sealed secrets"
  value       = var.dest_dir
  depends_on  = [null_resource.seal_secrets]
}
