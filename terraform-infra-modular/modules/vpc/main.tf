resource "aws_vpc" "cyber94_calculator_2_dpook_vpc_tf" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "cyber94_calculator_dpook_vpc"
  }
}

resource "aws_route53_zone" "cyber94_calculator_2_dpook_vpc_dns_tf" {
  name = "cyber-5.sparta"

  vpc{
    vpc_id = aws_vpc.cyber94_calculator_2_dpook_vpc_tf.id
  }

}
