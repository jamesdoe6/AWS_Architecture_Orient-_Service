module "compute" {
  source = "../../modules/compute"

  #   region                 = var.region
  project       = var.project
  author        = var.author
  environment   = var.environment
  instance_type = var.instance_type
  #   instance_ami           = var.instance_ami
  subnet_id = var.subnet_id
  #   vpc_id                 = var.vpc_id
  #   cidr                   = var.cidr
  #   igw                    = var.igw
  vpc_security_group_ids = var.vpc_security_group_ids
  public_key_path        = var.public_key_path
}
