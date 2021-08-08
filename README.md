# Sealed Secret util module

Module to encrypt or "seal" kube secrets using kubeseal cli and provided cert. Each of the yaml files in the `source_dir` is
encrypted with the cert and written into the `dest_dir` directory.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- None

### Terraform providers

- None

## Module dependencies

This module makes use of the output from other modules:

- None

## Example usage

```hcl-terraform
module "seal_secrets" {
  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = var.source_dir
  dest_dir      = var.dest_dir
  kubeseal_cert = var.kubeseal_cert
}
```
