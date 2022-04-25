
locals {
  tmp_dir = "${path.cwd}/.tmp/sealed_secrets"
  sealed_secrets_file = "${local.tmp_dir}/${var.label}.yaml"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["kubeseal", "kubectl"]
}

resource null_resource seal_secrets {
  provisioner "local-exec" {
    command = "${path.module}/scripts/seal-secrets.sh '${var.source_dir}' '${var.dest_dir}'"

    environment = {
      TMP_DIR = local.tmp_dir
      BIN_DIR = module.setup_clis.bin_dir
      KUBESEAL_CERT = var.kubeseal_cert
      ANNOTATIONS = join(" ", var.annotations)
    }
  }
}
