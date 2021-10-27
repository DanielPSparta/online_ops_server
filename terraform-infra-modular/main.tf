provider "aws" {
  region = var.var_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "web_subnet" {
  source = "./modules/web_subnet"

  var_aws_vpc_id = module.vpc.output_aws_vpc_id
  var_dns_zone_id = module.vpc.output_dns_zone_id
}

module "webserver" {
  source = "./modules/webserver"

  var_web_subnet_id = module.web_subnet.output_web_subnet_id
  var_ssh_key_name = var.var_ssh_key_name
  var_dns_zone_id = module.vpc.output_dns_zone_id
  var_aws_vpc_id = module.vpc.output_aws_vpc_id
}
