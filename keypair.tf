# Private Key and Keypair
## Create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## Create a key pair using above private key
resource "aws_key_pair" "keypair" {

  # Name of the Key
  key_name = var.keypair

  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

## Save the private key at the specified path
resource "local_file" "save-key" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${var.base_path}/${var.keypair}.pem"
}
