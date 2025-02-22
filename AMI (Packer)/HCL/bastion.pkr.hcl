# Packer HCL Configuration
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
# Define a variable for the AWS region with a default value
# variable "region" {
#   type    = string
#   default = "eu-west-2" # Default to London region
# }


# Create a local variable to generate a timestamp for unique AMI naming
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") # Remove special characters from the timestamp
}

# Define the Amazon EBS builder configuration
source "amazon-ebs" "terraform-bastion-prj-19" {
  ami_name      = "terraform-bastion-prj-19-${local.timestamp}" # Unique AMI name with timestamp
  instance_type = "t2.medium"                                    # Instance type to use for building the AMI
  region        = var.region                                    # AWS region to build the AMI in
  source_ami    = var.source_ami
  ssh_username  = "ec2-user" # Default SSH username for RHEL-based AMIs

  # Add tags to the AMI for better identification
  tags = merge(
    var.tags,
    {
      Name = "terraform-bastion-prj-19"
    }
  )
}

# Define the build process
build {
  sources = ["source.amazon-ebs.terraform-bastion-prj-19"] # Use the defined source block

  # Run a shell script to provision the instance
  provisioner "shell" {
    script = "bastion.sh" # Path to the shell script for setting up the bastion host
  }
}