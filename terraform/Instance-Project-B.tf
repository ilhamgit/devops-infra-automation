resource "aws_instance" "B" {
  ami                    = var.amiID[var.region]
  instance_type          = "t2.micro"
  key_name               = "dove-key"
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = var.zone1

  tags = {
    Name    = "Dove-B"
    Project = "Dove"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > private_ip-project-B.txt"
  }

}

resource "aws_ec2_instance_state" "ProjectB_state" {
  instance_id = aws_instance.web.id
  state       = "running"
}

output "ProjectBPublicIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.B.public_ip
}

output "ProjectBPrivateIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.B.private_ip
}