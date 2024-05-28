resource "aws_instance" "myec1" {
  ami                    = var.ami_new
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata.sh"))
  key_name               = aws_key_pair.login_key.id

  tags = {
    Name = "instance1"
  }
}

resource "aws_instance" "myec2" {
  ami                    = var.ami_new
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file("newdata.sh"))
  key_name               = aws_key_pair.login_key.id

  tags = {
    Name = "instance2"
  }
}

resource "aws_key_pair" "login_key" {
  key_name   = "terraform-login-key"
  public_key = var.unique_key
}