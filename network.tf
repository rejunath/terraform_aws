resource "aws_vpc" "custom_vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.cidr_sub1
  availability_zone       = var.sub1_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "demo-sub1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.cidr_sub2
  availability_zone       = var.sub2_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "demo-sub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "demo-igw"
  }

}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "demo-RT"
  }

}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_lb" "mylb" {
  name               = "mylb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.mysg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  tags = {
    Name = "my-lb"
  }

}

resource "aws_lb_target_group" "targetgp" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attchment1" {
  target_group_arn = aws_lb_target_group.targetgp.arn
  target_id        = aws_instance.myec1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "attchment2" {
  target_group_arn = aws_lb_target_group.targetgp.arn
  target_id        = aws_instance.myec2.id
  port             = 80

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.mylb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgp.arn
  }
}

output "loadbalancerdns" {
  value = aws_lb.mylb.dns_name

}