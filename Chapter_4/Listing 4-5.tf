provider "aws" {
    region = "us-east-1"
}

variable "awsprops" {
    type = map(string)
    default = {
        vpcid = "vpc-937e84ee"
        subnetid = "subnet-c10c6fcf"
        ami = "ami-059ff882c04ebed21"
        keyname = "my-key-pair"
        hostid = "h-xxxxxxxxxxxx"
        sourceip = "1.2.3.4/32"
    }
}

resource "aws_security_group" "ec2-mac-instance-sg" {

  description = "Enable SSH and VNC access to Mac Instance"
  vpc_id = lookup(var.awsprops, "vpcid")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [lookup(var.awsprops, "sourceip")]
  }

  // To Allow Port VNC Transport
  ingress {
    from_port = 5900
    protocol = "tcp"
    to_port = 5900
    cidr_blocks = [lookup(var.awsprops, "sourceip")]
  }
}

resource "aws_instance" "ec2-mac-instance" {
  ami = lookup(var.awsprops, "ami")
  key_name = lookup(var.awsprops, "keyname")
  host_id = lookup(var.awsprops, "hostid")
  instance_type = "mac1.metal"
  subnet_id = lookup(var.awsprops, "subnetid")
  vpc_security_group_ids = [
      aws_security_group.ec2-mac-instance-sg.id
  ] 
  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = "200"
  } 
}