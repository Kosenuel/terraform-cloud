region = "eu-west-2"

tags = {
    Owner = "DevOps Team"
    Project = "Terraform-Cloud"
    Environment = "dev"
}

source_ami          = "ami-0f9535ac605dc21d5" # Bro, remember to replace with the latest RHEL AMI ID. This is for web instances.
source_ami_ubuntu   = "ami-091f18e98bc129c4e" # Bro, remember to replace with the latest Ubuntu AMI ID
source_ami_bastion   = "ami-0aa938b5c246ef111" # Bro, remember to replace with the latest CentOs AMI ID