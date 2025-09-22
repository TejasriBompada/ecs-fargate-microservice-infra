locals {
  name = var.name != "" ? var.name : "bastion"
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "microservice-${var.env}-bastion-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.name}-ip-${substr(uuid(),0,8)}"
  role = aws_iam_role.ssm_role.name
}

# Ubuntu 24.04 LTS AMI (Canonical)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


# Bastion EC2
resource "aws_instance" "bastion" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  associate_public_ip_address = false  # always private

  user_data = templatefile("${path.module}/userdata.sh.tpl", {})

  tags = merge(var.tags, { Name = local.name })

  lifecycle {
    create_before_destroy = true
  }

}
