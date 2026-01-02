data "aws_vpc" "Myvpc" {
    id = var.My_Detailed_Network_Info.vpc_cidr
}


resource "aws_subnet" "Mysubnet" {
    count = local.value
    vpc_id = data.aws_vpc.Myvpc.id
    cidr_block = var.My_Detailed_Network_Info.subnet_info[0].subnet_cidr[count.index]
    tags = {
        Name = var.My_Detailed_Network_Info.subnet_info[0].subnet_names[count.index]
    }
    availability_zone = var.My_Detailed_Network_Info.subnet_info[0].subnet_az[count.index]
}


resource "aws_route_table" "Myroute" {
    vpc_id = aws_vpc.Myvpc.id
    tags = {
        Name = "Route_Table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MyIG.id
    }
}


resource "aws_route_table_association" "MyAssociation" {
    count = local.value
    route_table_id = aws_route_table.Myroute.id
    subnet_id = aws_subnet.Mysubnet[count.index].id
}


resource "aws_internet_gateway" "MyIG" {
    vpc_id = aws_vpc.Myvpc.id
    tags = {
        Name = "My_Internet_Gateway"
    }
}




resource "aws_security_group" "Mysecurity" {
    vpc_id = aws_vpc.Myvpc.id
    name = "My_Security_Group"
    description = "Creating Security Group"
    tags = {
        Name = "MYSG"
    }
}

resource "aws_vpc_security_group_ingress_rule" "Inbound" {
    security_group_id = aws_security_group.Mysecurity.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
} 


data "aws_ami" "AMI" {

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251212"]
    }
    owners = "099720109477"
}


resource "aws_instance" "My_EC2_instance"{
    ami = data.aws_ami.AMI.id
    instance_type = "t3.micro"
    key_name = aws_key_pair.Mykey.key_name
    associate_public_ip_address = true
    subnet_id = aws_subnet.Mysubnet[0].id
    vpc_security_group_ids = [aws_security_group.Mysecurity.id]
    tags = {
        Name = "My_EC2_Instance_Terraform"
    }
}


resource "aws_key_pair" "Mykey" {
    public_key = file("~/id_ed25519.pub")
    key_name = "Mykey"
}