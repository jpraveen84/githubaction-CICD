resource "aws_security_group" "access_for_port_80" { 
  count = length(var.pearl_sg_port)
  name        = "access_80"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.pear_vpc.id

  ingress {
    description      = "access_80"
    from_port        = var.pearl_sg_port[count.index]
    to_port          = var.pearl_sg_port[count.index]
    protocol         = "tcp"
    cidr_blocks      = var.pearl_sg
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "access_80"
  }
  
}

# data "sg_ids" "port_80" {
#     sg_id = aws_security_group.access_for_port_80
#     depends_on = [aws_security_group.access_for_port_80]
# }

resource "aws_security_group" "ecs_80" { 
  count = length(var.pearl_sg_port)
  name        = "ecs_80"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.pear_vpc.id

  ingress {
    description      = "ecs_80"
    from_port        = var.pearl_sg_port[count.index]
    to_port          = var.pearl_sg_port[count.index]
    protocol         = "tcp"
    security_groups  = [aws_security_group.access_for_port_80[0].id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "access_80"
  }
  
}