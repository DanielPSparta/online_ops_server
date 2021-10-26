# Threatspec Project Threat Model

A threatspec project.


# Diagram
![Threat Model Diagram](ThreatModel.md.png)



# Exposures


# Acceptances


# Transfers


# Mitigations


# Reviews


# Connections

## External:Guest To CalcApp:Web:Server:Index
HTTPs-GET

```
# @connects #guest to #index with HTTPs-GET

@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    print(request.headers)
    isUserLoggedIn = False

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:VPC To CalcApp:VPC:Internet_gateway
network traffic

```
# @connects #vpc to #igw with network traffic
resource "aws_vpc" "cyber94_full_dpook_vpc_tf" {
  cidr_block       = "10.105.0.0/16"
  tags = {
    Name = "cyber94_full_dpook_vpc"
  }

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Internet_gateway To CalcApp:VPC
network traffic

```
# @connects #igw to #vpc with network traffic
resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Internet_gateway To CalcApp:VPC:Routetable
network traffic

```
# @connects #igw to #rt with network traffic
resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Routetable To CalcApp:VPC:Internet_gateway
network traffic

```
# @connects #rt to #igw with network traffic
resource "aws_route_table" "cyber94_full_dpook_rt_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:SubnetApp
network traffic

```
# @connects #naclapp to #subnetapp with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_app_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.1.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_app"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:SubnetApp To CalcApp:VPC:NAClApp
network traffic

```
# @connects #subnetapp to #naclapp with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_app_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.1.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_app"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:SubnetSQL
network traffic

```
# @connects #naclsql to #subnetsql with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_db_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.2.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_db"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:SubnetSQL To CalcApp:VPC:NAClApp
network traffic

```
# @connects #subnetsql to #naclsql with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_db_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.2.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_db"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:Subnetbastion
network traffic

```
# @connects #naclbastion to #subnetbastion with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_bastion_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.3.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_bastion"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Subnetbastion To CalcApp:VPC:NAClApp
network traffic

```
# @connects #subnetbastion to #naclbastion with network traffic
resource "aws_subnet" "cyber94_full_dpook_subnet_bastion_tf" {
  vpc_id     = aws_vpc.cyber94_full_dpook_vpc_tf.id
  cidr_block = "10.105.3.0/24"
  tags = {
    Name = "cyber94_full_dpook_subnet_bastion"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Routetable To CalcApp:VPC:NAClApp
network traffic

```
# @connects #rt to #naclapp with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_app_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:Routetable
network traffic

```
# @connects #naclapp to #rt with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_app_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Routetable To CalcApp:VPC:NAClApp
network traffic

```
# @connects #rt to #naclbastion with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_bastion_tf" {

  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id]


```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:Routetable
network traffic

```
# @connects #naclbastion to #rt with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_bastion_tf" {

  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id]


```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Routetable To CalcApp:VPC:NAClApp
network traffic

```
# @connects #rt to #naclsql with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_db_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_db_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:NAClApp To CalcApp:VPC:Routetable
network traffic

```
# @connects #naclsql to #rt with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_db_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_db_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Security_group_app To CalcApp:VPC:SubnetApp
Network traffic

```
# @connects #sg_app to #subnetapp with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_app_tf" {
  name = "cyber94_full_dpook_sg_app"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{
    from_port = 22

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:SubnetApp To CalcApp:Web:Security_group_app
Network traffic

```
# @connects #subnetapp to #sg_app with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_app_tf" {
  name = "cyber94_full_dpook_sg_app"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{
    from_port = 22

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Security_group_SQL_server To CalcApp:VPC:SubnetSQL
Network traffic

```
# @connects #sg_sql to #subnetsql with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_db_tf" {

  name = "cyber94_full_dpook_sg_db"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:SubnetSQL To CalcApp:Web:Security_group_SQL_server
Network traffic

```
# @connects #subnetsql to #sg_sql with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_db_tf" {

  name = "cyber94_full_dpook_sg_db"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Security_group_bastion_server To CalcApp:VPC:Subnetbastion
Network traffic

```
# @connects #sg_bastion to #subnetbastion with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_bastion_tf" {

  name = "cyber94_full_dpook_sg_bastion"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:VPC:Subnetbastion To CalcApp:Web:Security_group_bastion_server
Network traffic

```
# @connects #subnetbastion to #sg_bastion with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_bastion_tf" {

  name = "cyber94_full_dpook_sg_bastion"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Security_group_app To CalcApp:Web:Server
Network

```
# @connects #sg_app to #app_server with Network

resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Server To CalcApp:Web:Security_group_app
Network

```
# @connects #app_server to #sg_app with Network

resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Server To CalcApp:SQL:Server
SQL request

```
# @connects #app_server to #sql_server with SQL request

resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:bastion:Server To CalcApp:SQL:Server
SSH_Responce

```
# @connects #bastion_server to #sql_server with SSH_Responce

resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id
  ami = "ami-0d1c7c4de1f4cdc9a"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:SQL:Server To 
SQL responce

```
# @connects #sql_server to #web_server with SQL responce

resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id
  ami = "ami-0d1c7c4de1f4cdc9a"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:Web:Security_group_bastion_server To CalcApp:bastion:Server
Network

```
# @connects #sg_bastion to #bastion_server with Network

resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:bastion:Server To CalcApp:Web:Security_group_bastion_server
Network

```
# @connects #bastion_server to #sg_bastion with Network

resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## CalcApp:SQL:Server To CalcApp:bastion:Server
SSH_Request

```
# @connects #sql_server to #bastion_server with SSH_Request

resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1


# Components

## External:Guest

## CalcApp:Web:Server:Index

## CalcApp:VPC

## CalcApp:VPC:Internet_gateway

## CalcApp:VPC:Routetable

## CalcApp:VPC:NAClApp

## CalcApp:VPC:SubnetApp

## CalcApp:VPC:NAClApp

## CalcApp:VPC:SubnetSQL

## CalcApp:VPC:NAClApp

## CalcApp:VPC:Subnetbastion

## CalcApp:Web:Security_group_app

## CalcApp:Web:Security_group_SQL_server

## CalcApp:Web:Security_group_bastion_server

## CalcApp:Web:Server

## CalcApp:SQL:Server

## CalcApp:bastion:Server

## 


# Threats


# Controls
