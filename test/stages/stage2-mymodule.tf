module "seal_secrets" {
  source = "./module"

  source_dir = "${path.cwd}/secrets"
  dest_dir = "${path.cwd}/sealed-secrets"
  label = "test"
  kubeseal_cert = module.cert.cert
}
