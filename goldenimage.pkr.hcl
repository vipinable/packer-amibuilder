build {
  name = "packer-golden"
  sources = [
    "source.amazon-ebs.packer-builder"
  ]

  # Add SSH public key
  provisioner "file" {
    source      = "../packer.pub"
    destination = "/tmp/learn-packer.pub"
  }

  # Execute setup script
  provisioner "shell" {
    script = "setup.sh"
    # Run script after cloud-init finishes, otherwise you run into race conditions
    execute_command = "/usr/bin/cloud-init status --wait && sudo -E -S sh '{{ .Path }}'"
  }

}

source "amazon-ebs" "packer-builder" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  source_ami    = data.hcp-packer-image.golden_base_east.id
  ssh_username = "ubuntu"
  tags = {
    Name          = "packer-builder"
    environment   = "production"
  }
  snapshot_tags = {
    environment   = "production"
  }
}
