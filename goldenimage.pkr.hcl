variable "ami_prefix" {
  type = string
  default = "pkr"
}

data "amazon-ami" "aws-default-image" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

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
  ami_name      = "${var.ami_prefix}-timestamp()
  instance_type = "t2.micro"
  source_ami    = data.amazon-ami.aws-default-image.id
  ssh_username = "ubuntu"
  tags = {
    Name          = "packer-builder"
    environment   = "production"
  }
  snapshot_tags = {
    environment   = "production"
  }
}
