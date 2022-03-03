variable "source_dir" {
  type        = string
  description = "The directory containing the secrets that will be encrypted using the cert"
}

variable "dest_dir" {
  type        = string
  description = "The directory where the sealed secrets will be written. If the directory does not exist it will be created"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
}

variable "label" {
  type        = string
  description = "The label for the collection of secrets"
}
