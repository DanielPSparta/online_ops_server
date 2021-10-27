#resource "aws_security_group" "cyber94_" {
#
##

resource "aws_instance" "cyber94_calculator_2_dpook_webserver_tf" {
  ami = var.var_aws_ami_ubuntu_1804
  instance_type = "t2.micro"
  subnet_id = var.var_web_subnet_id

  associate_public_ip_address = true

  key_name = var.var_ssh_key_name

  tags = {
    Name = "cyber94_calculator_2_dpook_webserver"
  }
}

resource "aws_route53_record" "cyber94_calculator_2_dpook_webserver_dns_tf" {
  zone_id = var.var_dns_zone_id
  name = "www"
  type = "A"
  ttl = "30"
  records = [aws_instance.cyber94_calculator_2_dpook_webserver_tf.public_ip]
}
