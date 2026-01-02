output "vpc_id" {
    value = var.My_Detailed_Network_Info.vpc_cidr

}

output "subnet" {
    value = var.My_Detailed_Network_Info.subnet_info
}

output "Route_Table" {
    value = aws_route_table.Myroute.id
}

output "Internet_Gateway" {
    value = aws_internet_gateway.MyIG.id
}


output "security_groups" {
    value = aws_security_group.Mysecurity.id
}

output "EC2-Instance" {
    value = aws_instance.My_EC2_instance.id
}


output "Public_Ip" {
    value = aws_instance.My_EC2_instance.public_ip
}

output "aws_ami_image" {
    value = aws_instance.My_EC2_instance.ami
}