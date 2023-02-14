#Define the EC2 instance
resource "aws_instance" "Ubuntu_test" {
  ami           = "ami-03e08697c325f02ab"
  instance_type = "t2.micro"
  key_name      = "ktkeypair"

  #Define security group for the instance
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  
  #Run the following to start the Docker containers
user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install curl -y
sudo apt install -y docker.io
sudo systemctl start docker

# Pull the koremori/my-flask-app:vanilla image (my small app that shows simple system information)
sudo docker pull koremori/my-flask-app:vanilla

# Start container2 with the koremori/my-flask-app:vanilla image on port 80
sudo docker run -d --name=container2 -p 80:5000 koremori/my-flask-app:vanilla

EOF

}


#Define the security group for the instance that allows ssh access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_from_anywhere"
  description = "Allow ssh access from 0.0.0.0/0"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Define the security group for the instance that allows http access to the container
resource "aws_security_group" "allow_http" {
  name        = "allow_http_from_anywhere"
  description = "Allow http access from 0.0.0.0/0"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outgoing traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
