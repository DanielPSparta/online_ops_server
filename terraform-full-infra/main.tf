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

# @component Internet:Developer_Computer (#dev)

# @control Strong passwords and security on developer pc (#devprotect)
# @threat Intruder on developer pc, elevation of privilege (#devintruder)
# @mitigates #dev against #devintruder with #devprotect

# @control Jenkins test code before deployment and integration (#devtest)
# @threat uploading broken code (#devbroke)
# @mitigates #dev against #devbroke with #devtest

# @control Strong passwords and security on developer pc (#devprotect)
# @threat Intruder on developer pc, tampering with source code (#devtamper)
# @mitigates #dev against #devtamper with #devprotect




# @component TerraformAWS:VPC (#vpc)
# @connects #vpc to #dev with SSH,HTTP,HTTPs,Ephemeral
# @connects #dev to #vpc with SSH,HTTP,HTTPs,Ephemeral
# @connects #vpc to #igw with SSH,HTTP,HTTPs,Ephemeral
resource "aws_vpc" "cyber94_full_dpook_vpc_tf" {
  cidr_block       = "10.105.0.0/16"
  tags = {
    Name = "cyber94_full_dpook_vpc"
  }
}



# @component TerraformAWS:VPC:Internet_gateway (#igw)
# @connects #igw to #vpc with SSH,HTTP,HTTPs,Ephemeral
# @connects #igw to #rt with SSH,HTTP,HTTPs,Ephemeral
resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"
  }
}

# @component TerraformAWS:VPC:Routetable (#rt)
# @connects #rt to #igw with SSH,HTTP,HTTPs,Ephemeral
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


# @component TerraformAWS:VPC:SubnetApp (#subnetapp)
# @connects #naclapp to #subnetapp with SSH,HTTPs,Ephemeral
# @connects #subnetapp to #naclapp with SSH,HTTPs,Ephemeral
resource "aws_subnet" "cyber94_full_dpook_subnet_app_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.1.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_app"
  }
}

# @component TerraformAWS:VPC:SubnetSQL (#subnetsql)
# @connects #naclsql to #subnetsql with SSH,SQL
# @connects #subnetsql to #naclsql with SSH,SQL
resource "aws_subnet" "cyber94_full_dpook_subnet_db_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.2.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_db"
  }
}

# @component TerraformAWS:VPC:Subnetbastion (#subnetbastion)
# @connects #naclbastion to #subnetbastion with SSH
# @connects #subnetbastion to #naclbastion with SSH
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


# @component TerraformAWS:VPC:SubnetApp:NAClApp (#naclapp)
# @connects #rt to #naclapp with SSH,HTTP,HTTPs,Ephemeral
# @connects #naclapp to #rt with SSH,HTTP,HTTPs,Ephemeral
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

# @component TerraformAWS:VPC:Subnetbastion:NAClBastion (#naclbastion)
# @connects #rt to #naclbastion with SSH
# @connects #naclbastion to #rt with SSH
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

# @component TerraformAWS:VPC:SubnetSQL:NAClSQL (#naclsql)

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


# @component TerraformAWS:VPC:Security_group_app (#sg_app)
# @connects #sg_app to #subnetapp with SSH,HTTP,HTTPs,Ephemeral,SQL
# @connects #subnetapp to #sg_app with SSH,HTTP,HTTPs,Ephemeral,SQL
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

# @component TerraformAWS:VPC:Security_group_SQL_server (#sg_sql)
# @connects #sg_sql to #subnetsql with SSH,SQL
# @connects #subnetsql to #sg_sql with SSH,SQL
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

# @component TerraformAWS:VPC:Security_group_bastion_server (#sg_bastion)
# @connects #sg_bastion to #subnetbastion with SSH
# @connects #subnetbastion to #sg_bastion with SSH
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




# @component TerraformAWS:Web_Server (#app_server)
# @connects #sg_app to #app_server with SSH,HTTP,HTTPs,Ephemeral,SQL
# @connects #app_server to #sg_app with SSH,HTTP,HTTPs,Ephemeral,SQL

# @connects #naclapp to #naclsql with SQL request


# @threat DDOS (#ddos)
# @exposes #app_server to Out of service with not using IDP

# @control Only listen on needed ports (#portsniffdefense)
# @threat Port sniffing for open ports (#portsniff)
# @mitigates #app_server against #portsniff with #portsniffdefense

# @control only allow SSH connections to ubuntu user from specific ip (#ubuntuprotect)
# @threat access to ubuntu allows access to database (#ubuntuaccess)
# @mitigates #app_server against #ubuntuaccess with #ubuntuprotect

# @control Use proxy server to access all servers in vpc (#infraprotect)
# @threat Network mapping of cloud servers (#networkmap)
# @mitigates #app_server against #networkmap with #infraprotect

# @exposes #app_server to overwriting memory of backend web processes. throws sevrer 500 error with #buffover
# @exposes #app_server to tampering manipulation with #csrf

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

# @component TerraformAWS:SQL_Server (#sql_server)
# @connects #sg_sql to #sql_server with Network traffic
# @connects #sql_server to #sg_sql with Network traffic

# @connects #naclsql to #naclbastion with SSH_Responce
# @connects #naclsql to #naclapp with SQL Responce

# @threat credentials exposed in plain text (#credential)
# @exposes #sql_server to credential exposure with credentials stored unhashed

#sql_server_server against #networkmap with #infraprotect

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

# @component TerraformAWS:bastion_Server (#bastion_server)
# @connects #sg_bastion to #bastion_server with SSH
# @connects #bastion_server to #sg_bastion with SSH

# @connects #naclbastion to #naclsql with SSH_Request

# @control NACL and security group IP check (#ip)
# @threat intruder SSH connection (#ssh)
# @mitigates #bastion_server against #ssh with #ip

# @control Only developer computer IP allowed through (#devip)
# @threat open ports on with public ip (#ipport)
# @mitigates #bastion_server against #ipport with #devip

# @mitigates #bastion_server against #ubuntuaccess with #ubuntuprotect
@mitigates #bastion_server against #networkmap with #infraprotect
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
