resource "aws_instance" "web" {
  ami                    = var.amiID[var.region]
  instance_type          = "t2.micro"
  key_name               = "dove-key"
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = var.zone1

  tags = {
    Name    = "Dove-A"
    Project = "Dove"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > private_ip-project-A.txt"
  }

}

resource "aws_ec2_instance_state" "ProjectA-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}

output "ProjectAPublicIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.web.public_ip
}

output "ProjectAPrivateIP" {
  description = "AMI ID of Ubuntu instance"
  value       = aws_instance.web.private_ip
}