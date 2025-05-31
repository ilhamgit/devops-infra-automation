resource "aws_security_group" "dove-sg" {
  name        = "dove-sg"
  description = "dove-sg"
  tags = {
    Name = "dove-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sshfromyIP" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_cadvisor" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv4         = "172.31.0.0/16"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_node_exporter" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv4         = "172.31.0.0/16"
  from_port         = 9100
  ip_protocol       = "tcp"
  to_port           = 9100
}


resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6" {
  security_group_id = aws_security_group.dove-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}