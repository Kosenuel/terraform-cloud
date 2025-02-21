# Packer HCL ConfigurationA
# locals {
#   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
# }

source "amazon-ebs" "terraform-web-prj-19" {
  ami_name      = "terraform-web-prj-19-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami    = var.source_ami
  ssh_username  = "ec2-user"
  tags = merge(
    var.tags,
    {
      Name = "terraform-web-prj-19"
    }
  )
}

build {
  sources = ["source.amazon-ebs.terraform-web-prj-19"]

  provisioner "shell" {
    script = "web.sh"
  }
}