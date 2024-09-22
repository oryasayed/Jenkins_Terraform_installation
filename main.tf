
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

