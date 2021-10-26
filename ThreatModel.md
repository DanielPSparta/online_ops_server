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

## TerraformAWS:Web_Server To CalcApp:Web_Server:Index
Hosting

```
# @connects #app_server to #index with Hosting


@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    print(request.headers)

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## Internet:Guest To CalcApp:Web_Server:Index
HTTPs-GET

```
# @connects #guest to #index with HTTPs-GET

@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    print(request.headers)
    isUserLoggedIn = False

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Index To Internet:Guest
HTTPs-GET

```
# @connects #index to #guest with HTTPs-GET

@flask_app.route('/', methods = ['POST','GET'])
def index_page():
    print(request.headers)
    isUserLoggedIn = False

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Index With CalcApp:Web_Server:Login
HTTPs-POST

```
# @connects #index with #login with HTTPs-POST
def login_page():
    return render_template('login.html')

@flask_app.route('/index')
def index2_page():

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Login With CalcApp:Web_Server:Index
HTTPs-POST

```
# @connects #login with #index with HTTPs-POST
def login_page():
    return render_template('login.html')

@flask_app.route('/index')
def index2_page():

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Accountcreation With CalcApp:Web_Server:Accountcreated
HTTPs-POST

```
# @connects #ac with #acd with HTTPs-POST

@flask_app.route('/addlogin', methods = ['POST'])
def addlogin_page():
    return render_template('addlogin.html')


```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Login With CalcApp:Web_Server:Accountcreation
HTTPs-POST

```
# @connects #login with #ac with HTTPs-POST

@flask_app.route('/addlogin', methods = ['POST'])
def addlogin_page():
    return render_template('addlogin.html')


```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Accountcreated With CalcApp:Web_Server:Login
HTTPs-POST

```
# @connects #acd with #login with HTTPs-POST
@flask_app.route('/accountcreated', methods = ['POST'])
def accountcreated_page():

    password = data['password']


```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Login To CalcApp:Web_Server:Authenticated
HTTPs-POST

```
# @connects #login to #auth with HTTPs-POST
def authenticate_users():
    password = data['password']
    check = sq.check_user_in_db(username,password)
    if check == True:
        user_token = create_token(username,password, 1200)

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Authenticated To CalcApp:Web_Server:Index
HTTPS-GET

```
# @connects #auth to #index with HTTPS-GET
def authenticate_users():
    password = data['password']
    check = sq.check_user_in_db(username,password)
    if check == True:
        user_token = create_token(username,password, 1200)

```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## CalcApp:Web_Server:Index To CalcApp:Web_Server:logout
HTTPs-POST

```
# @connects #index to #logout with HTTPs-POST
@flask_app.route('/logout', methods = ['POST','GET'])
def logout():
    resp = make_response(render_template('login.html'))
    return resp


```
/home/kali/cyber/projects2/online_ops/app/main.py:1

## TerraformAWS:VPC To Internet:Guest
network traffic

```
# @connects #vpc to #guest with network traffic
resource "aws_vpc" "cyber94_full_dpook_vpc_tf" {
  cidr_block       = "10.105.0.0/16"
  tags = {
    Name = "cyber94_full_dpook_vpc"
  }

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## Internet:Guest To TerraformAWS:VPC
network traffic

```
# @connects #guest to #vpc with network traffic
resource "aws_vpc" "cyber94_full_dpook_vpc_tf" {
  cidr_block       = "10.105.0.0/16"
  tags = {
    Name = "cyber94_full_dpook_vpc"
  }

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC To TerraformAWS:VPC:Internet_gateway
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

## TerraformAWS:VPC:Internet_gateway To TerraformAWS:VPC
network traffic

```
# @connects #igw to #vpc with network traffic
resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Internet_gateway To TerraformAWS:VPC:Routetable
network traffic

```
# @connects #igw to #rt with network traffic
resource "aws_internet_gateway" "cyber94_full_dpook_igw_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  tags = {
    Name = "cyber94_full_dpook_igw"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Routetable To TerraformAWS:VPC:Internet_gateway
network traffic

```
# @connects #rt to #igw with network traffic
resource "aws_route_table" "cyber94_full_dpook_rt_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetApp:NAClApp To TerraformAWS:VPC:SubnetApp
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

## TerraformAWS:VPC:SubnetApp To TerraformAWS:VPC:SubnetApp:NAClApp
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

## TerraformAWS:VPC:SubnetSQL:NAClSQL To TerraformAWS:VPC:SubnetSQL
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

## TerraformAWS:VPC:SubnetSQL To TerraformAWS:VPC:SubnetSQL:NAClSQL
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

## TerraformAWS:VPC:Subnetbastion:NAClBastion To TerraformAWS:VPC:Subnetbastion
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

## TerraformAWS:VPC:Subnetbastion To TerraformAWS:VPC:Subnetbastion:NAClBastion
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

## TerraformAWS:VPC:Routetable To TerraformAWS:VPC:SubnetApp:NAClApp
network traffic

```
# @connects #rt to #naclapp with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_app_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetApp:NAClApp To TerraformAWS:VPC:Routetable
network traffic

```
# @connects #naclapp to #rt with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_app_tf.id]

  egress {

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Routetable To TerraformAWS:VPC:Subnetbastion:NAClBastion
network traffic

```
# @connects #rt to #naclbastion with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_bastion_tf" {

  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id]


```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Subnetbastion:NAClBastion To TerraformAWS:VPC:Routetable
network traffic

```
# @connects #naclbastion to #rt with network traffic
resource "aws_network_acl" "cyber94_full_dpook_nacl_bastion_tf" {

  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id]


```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Security_group_app To TerraformAWS:VPC:SubnetApp
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

## TerraformAWS:VPC:SubnetApp To TerraformAWS:VPC:Security_group_app
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

## TerraformAWS:VPC:Security_group_SQL_server To TerraformAWS:VPC:SubnetSQL
Network traffic

```
# @connects #sg_sql to #subnetsql with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_db_tf" {

  name = "cyber94_full_dpook_sg_db"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetSQL To TerraformAWS:VPC:Security_group_SQL_server
Network traffic

```
# @connects #subnetsql to #sg_sql with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_db_tf" {

  name = "cyber94_full_dpook_sg_db"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Security_group_bastion_server To TerraformAWS:VPC:Subnetbastion
Network traffic

```
# @connects #sg_bastion to #subnetbastion with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_bastion_tf" {

  name = "cyber94_full_dpook_sg_bastion"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Subnetbastion To TerraformAWS:VPC:Security_group_bastion_server
Network traffic

```
# @connects #subnetbastion to #sg_bastion with Network traffic
resource "aws_security_group" "cyber94_full_dpook_sg_bastion_tf" {

  name = "cyber94_full_dpook_sg_bastion"
  vpc_id = aws_vpc.cyber94_full_dpook_vpc_tf.id
  ingress{

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Security_group_app To TerraformAWS:Web_Server
Network

```
# @connects #sg_app to #app_server with Network


resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:Web_Server To TerraformAWS:VPC:Security_group_app
Network

```
# @connects #app_server to #sg_app with Network


resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetApp:NAClApp To TerraformAWS:VPC:SubnetSQL:NAClSQL
SQL request

```
# @connects #naclapp to #naclsql with SQL request

resource "aws_instance" "cyber94_full_dpook_app_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_app_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Security_group_SQL_server To TerraformAWS:SQL_Server
Network traffic

```
# @connects #sg_sql to #sql_server with Network traffic



resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:SQL_Server To TerraformAWS:VPC:Security_group_SQL_server
Network traffic

```
# @connects #sql_server to #sg_sql with Network traffic



resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetSQL:NAClSQL To TerraformAWS:VPC:Subnetbastion:NAClBastion
SSH_Responce

```
# @connects #naclsql to #naclbastion with SSH_Responce


resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id
  ami = "ami-0d1c7c4de1f4cdc9a"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:SubnetSQL:NAClSQL To TerraformAWS:VPC:SubnetApp:NAClApp
SQL Responce

```
# @connects #naclsql to #naclapp with SQL Responce


resource "aws_instance" "cyber94_full_dpook_db_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_db_tf.id
  ami = "ami-0d1c7c4de1f4cdc9a"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Security_group_bastion_server To TerraformAWS:bastion_Server
Network

```
# @connects #sg_bastion to #bastion_server with Network


resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:bastion_Server To TerraformAWS:VPC:Security_group_bastion_server
Network

```
# @connects #bastion_server to #sg_bastion with Network


resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1

## TerraformAWS:VPC:Subnetbastion:NAClBastion To TerraformAWS:VPC:SubnetSQL:NAClSQL
SSH_Request

```
# @connects #naclbastion to #naclsql with SSH_Request

resource "aws_instance" "cyber94_full_dpook_bastion_tf" {
  subnet_id = aws_subnet.cyber94_full_dpook_subnet_bastion_tf.id
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/cyber/projects2/online_ops/terraform-full-infra/main.tf:1


# Components

## TerraformAWS:Web_Server

## CalcApp:Web_Server:Index

## Internet:Guest

## CalcApp:Web_Server:Login

## CalcApp:Web_Server:Accountcreation

## CalcApp:Web_Server:Accountcreated

## CalcApp:Web_Server:Authenticated

## CalcApp:Web_Server:logout

## TerraformAWS:VPC

## TerraformAWS:VPC:Internet_gateway

## TerraformAWS:VPC:Routetable

## TerraformAWS:VPC:SubnetApp:NAClApp

## TerraformAWS:VPC:SubnetApp

## TerraformAWS:VPC:SubnetSQL:NAClSQL

## TerraformAWS:VPC:SubnetSQL

## TerraformAWS:VPC:Subnetbastion:NAClBastion

## TerraformAWS:VPC:Subnetbastion

## TerraformAWS:VPC:Security_group_app

## TerraformAWS:VPC:Security_group_SQL_server

## TerraformAWS:VPC:Security_group_bastion_server

## TerraformAWS:SQL_Server

## TerraformAWS:bastion_Server


# Threats


# Controls
