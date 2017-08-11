# You need to enter you valid access_key and secret_key

provider "aws" {
    access_key = "####"
    secret_key = "####"
    region = "us-east-2"
}


resource "aws_security_group" "infrastructure-as-code" {

  name = "infrastructure-as-code"

  description = "infrastructure-as-code security group."
  #vpc_id = [ ]
  
  # This rule is login to the instance from your IP address using port 22
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "#.#.#.#/32" ] 
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
  
}

resource "aws_instance" "infrastructure-as-code" {
  
  subnet_id = "subnet-67972b1c"

  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.infrastructure-as-code.id}" ]
  associate_public_ip_address = false
 
  tags {
    Name = "w1-infrastructure-as-code"
  }
  key_name = "helloworld"
  
  # Keep these arguments as is:
  ami = "ami-8a7859ef"
  #availability_zone = "us-east-2"
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",

    ]
	connection {
    type     = "ssh"
    user     = "ec2-user"
	private_key = "${file("helloworld.pem")}"
  }
  }
  
}
