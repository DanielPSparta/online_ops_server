provider "aws" {
  region = "eu-west-1"
  #shared_credentials_file = "~/.aws/credentials"
  #access_key = ""
  #secret_key = ""
}



terraform {
  backend "s3" {
    bucket = "cyber94-dpook-bucket"
    key = "tfstate/terraform_full_infra_calculator/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "cyber94_dpook_dynamodb_table_lock_calculator"
    encrypt = true
  }
}



resource "aws_vpc" "cyber94_full_dpook_vpc_tf" {
  cidr_block       = "10.105.0.0/16"
  tags = {
    Name = "cyber94_full_dpook_vpc"
  }
}




resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"
  }
}

resource "aws_route_table" "cyber94_full_dpook_rt_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_full_dpook_igw_tf.id
  }
  tags = {
    Name = "cyber94_full_dpook_rt"
  }
}



resource "aws_subnet" "cyber94_full_dpook_subnet_app_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.1.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_app"
  }
}

resource "aws_subnet" "cyber94_full_dpook_subnet_db_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.2.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_db"
  }
}

resource "aws_subnet" "cyber94_full_dpook_subnet_bastion_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.3.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_bastion"
  }
}




resource "aws_route_table_association" "cyber94_full_dpook_rt_association_app_tf" {
    subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
    route_table_id = aws_route_table.cyber94_full_dpook_rt_tf.id
}

resource "aws_route_table_association" "cyber94_full_dpook_rt_association_bastion_tf" {
    subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
    route_table_id = aws_route_table.cyber94_full_dpook_rt_tf.id
}



resource "aws_network_acl" "cyber94_full_dpook_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_app_tf.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress{
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "10.105.2.0/24"
    from_port  = 3306
    to_port    = 3306
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 5000
    to_port    = 5000
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 600
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  tags = {
    Name = "cyber94_full_dpook_nacl_app"
  }
}

resource "aws_network_acl" "cyber94_full_dpook_nacl_bastion_tf" {

  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id]

  egress {

    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "10.105.2.0/24"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80

  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443

  }

  tags = {
    Name = "cyber94_full_dpook_nacl_bastion"
  }
}

resource "aws_network_acl" "cyber94_full_dpook_nacl_db_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_db_tf.id]

  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "10.105.1.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.105.3.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.105.3.0/24"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.105.1.0/24"
    from_port  = 3306
    to_port    = 3306

  }

  tags = {
    Name = "cyber94_full_dpook_nacl_db"
  }
}



resource "aws_security_group" "cyber94_full_dpook_sg_app_tf" {
  name = "cyber94_full_dpook_sg_app"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.105.2.0/24"]
  }

  tags = {
    Name = "cyber94_full_dpook_sg_app"
  }
}

resource "aws_security_group" "cyber94_full_dpook_sg_db_tf" {

  name = "cyber94_full_dpook_sg_db"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.105.3.0/24"]
  }

  ingress{
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.105.1.0/24"]
  }


  tags = {
   Name = "cyber94_full_dpook_sg_db"
  }
}

resource "aws_security_group" "cyber94_full_dpook_sg_bastion_tf" {

  name = "cyber94_full_dpook_sg_bastion"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cyber94_full_dpook_sg_bastion"
  }
}





resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-dpook"
  vpc_security_group_ids = [aws_security_group.cyber94_full_dpook_sg_app_tf.id]
  #count = 3
  associate_public_ip_address = true
  tags = {
    Name = "cyber94_full_dpook_server_app"
  }
  lifecycle {
    create_before_destroy = true
  }

  #just to make sure that terraform will not continue to loal exec before the server is up.
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/cyber/key_aws/cyber94-dpook.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "pwd"
    ]
  }


  #to provision the server using ansible
  provisioner "local-exec" {
    working_dir = "../ansible-full-infra"
    command = "ansible-playbook -i ${self.public_ip}, -u ubuntu playbook.yml"

  }


 /*  this is too downlaod docker using terraform directly
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/cyber/key_aws/cyber94-dpook.pem")
  }

  provisioner "file" {
    source = "../init-scripts/docker-install.sh"
    destination = "/home/ubuntu/docker-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 777 /home/ubuntu/docker-install.sh",
      "/home/ubuntu/docker-install.sh"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "docker run hello-world",
    ]
  } */
}

resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id
  ami = "ami-0d1c7c4de1f4cdc9a"
  instance_type = "t2.micro"
  key_name = "cyber94-dpook"
  vpc_security_group_ids = [aws_security_group.cyber94_full_dpook_sg_db_tf.id]


  tags = {
    Name = "cyber94_full_dpook_server_db"
  }
}

resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-dpook"
  vpc_security_group_ids = [aws_security_group.cyber94_full_dpook_sg_bastion_tf.id]
  associate_public_ip_address = true
  tags = {
    Name = "cyber94_full_dpook_server_bastion"
  }
}
