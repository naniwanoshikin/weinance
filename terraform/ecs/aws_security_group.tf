resource "aws_security_group" "instance" {
  name        = "instance"
  description = "instance sg"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "rails_i_sg"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    security_groups = [
      aws_security_group.alb.id,
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "sample-rails-alb"
  description = "http and https"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "rails_alb_sg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # httpsでのアクセス許可
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "sample-db"
  description = "DB"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "rails_db_sg"
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.instance.id,
    ]
  }
}