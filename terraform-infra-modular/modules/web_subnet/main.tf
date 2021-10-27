resource "aws_subnet" "cyber94_calculator_2_dpook_subnet_web_tf" {
  vpc_id = var.var_aws_vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cyber94_calculator_2_dpook_subnet_web"
  }
}
