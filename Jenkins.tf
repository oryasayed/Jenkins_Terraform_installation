
provider "aws" {

    region = "us-east-1"
  
}

resource "aws_instance" "jenkins" {
    ami           = "ami-0ebfd941bbafe70c6"
    subnet_id =  "subnet-06b5fc79ca1cf66fd"  
    instance_type = "t2.micro"
    user_data = <<-EOF
      #!/bin/bash
      sudo yum update -y  
      sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo  
      sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key  
      sudo yum upgrade -y 
      sudo dnf install java-11-amazon-corretto -y  
      sudo yum install jenkins -y  
      sudo systemctl enable jenkins  
      sudo systemctl start jenkins  
    EOF
   tags = {
      Name = "Jenkins Server"
  } 
}


#Create security group 
resource "aws_security_group" "myjenkins_sg" {
  name        = "jenkins_sg20"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = "vpc-0eedff4beb2add0c1"

  #Allow incoming TCP requests on port 22 from any IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#Allow incoming TCP requests on port 443 from any IP
  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




