author    = "Jeremie"
project   = "kube"
subnet_id = "subnet-0af4f8bcc527df86e"
# vpc_id                 = "vpc-0ebcdb39f7a526ef9"
# cidr                   = "172.31.0.0/16"
# igw                    = "igw-06d61463409eb8f84"
vpc_security_group_ids = ["sg-0ae7210b1a828a370"]
region                 = "eu-west-3"
instance_type          = "t2.micro"

environment = "dev"
# instance_ami    = "ami-0e207c18bb303cc68"
public_key_path = "/home/jdoe/.ssh/jeremie-key.pub"
