# Generate Key
resource "tls_private_key" "manaya-tf-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

# Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "manaya-tf-ami"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  tags {
    Name = "HelloWorld"
  }
}

# Launch Config
resource "aws_launch_configuration" "launch_conf" {
  name          = "manaya-tf-launchconf"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_id
  key_name      = aws_key_pair.my_aws_key.key_name
}