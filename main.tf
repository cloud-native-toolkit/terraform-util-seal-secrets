
locals {
  tmp_dir = "${path.cwd}/.tmp/sealed_secrets"
  sealed_secrets_file = "${local.tmp_dir}/${var.label}.yaml"
  sealed_secrets = yamldecode(data.local_file.sealed_secrets.content)
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource seal_secrets {
  provisioner "local-exec" {
    command = "${path.module}/scripts/seal-secrets.sh '${var.source_dir}' '${var.dest_dir}' '${local.sealed_secrets_file}'"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
      KUBESEAL_CERT = var.kubeseal_cert
    }
  }
}

data local_file sealed_secrets {
  depends_on = [null_resource.seal_secrets]

  filename = local.sealed_secrets_file
}
