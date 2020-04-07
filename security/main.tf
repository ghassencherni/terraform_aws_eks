#----security/main.tf----

# Creation of the public security group 
resource "aws_security_group" "wordpress_public_sg" {
  name        = "wordpress_public_sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.wordpress_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "artifakt-cluster-ingress-workstation-https" {
  # it's highly recommended to put your public IP in order to interract with you cluster, for this assement I will allow all IPs
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.wordpress_public_sg.id}"
  to_port           = 443
  type              = "ingress"
}

# Creation of the private security group
# Used for the RDS connexions 
resource "aws_security_group" "wordpress_private_sg" {
  name        = "wordpress_private_sg"
  description = "Used for RDS connexions"
  vpc_id      = "${var.wordpress_vpc_id}"

  #MYSQL
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    # Allow our kubernetes artifakt cluster to reach the RDS database
    cidr_blocks = ["${var.public_cidr_subnet}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
