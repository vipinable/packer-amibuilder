build {
  name = "packer-golden"
  sources = [
    "source.amazon-ebs.base_east",
    "source.amazon-ebs.base_west"
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
