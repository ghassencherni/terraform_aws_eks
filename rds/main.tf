#----rds/main.tf----

# Création de la RDS ( base de donnée pour wordpress )
resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7.22"
  instance_class         = "${var.db_instance_class}"
  identifier             = "${var.dbname}"
  name                   = "${var.dbname}"
  username               = "${var.dbuser}"
  password               = "${var.dbpassword}"
  vpc_security_group_ids = ["${var.wordpress_private_sg_id}"]
  db_subnet_group_name   = "${var.wordpress_db_subnet_group_name}"

  # Final DB snapshot not created before the DB instance is deleted
  skip_final_snapshot = true
}
