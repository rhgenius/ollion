resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "${var.project_name}-${var.environment}-redshift-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-redshift-subnet-group"
    Environment = var.environment
  }
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier        = "${var.project_name}-${var.environment}-cluster"
  database_name             = "${replace(var.project_name, "-", "_")}_${var.environment}"
  master_username           = "admin"
  master_password           = random_password.redshift_password.result
  node_type                 = var.node_type
  cluster_type              = var.number_of_nodes > 1 ? "multi-node" : "single-node"
  number_of_nodes           = var.number_of_nodes > 1 ? var.number_of_nodes : null
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids    = var.security_group_ids
  skip_final_snapshot       = true
  publicly_accessible       = false
  encrypted                 = true

  tags = {
    Name        = "${var.project_name}-redshift-cluster"
    Environment = var.environment
  }
}

resource "random_password" "redshift_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store the password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "redshift_credentials" {
  name        = "${var.project_name}/${var.environment}/redshift"
  description = "Redshift credentials for ${var.project_name} ${var.environment}"

  tags = {
    Name        = "${var.project_name}-redshift-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "redshift_credentials" {
  secret_id = aws_secretsmanager_secret.redshift_credentials.id
  secret_string = jsonencode({
    username = aws_redshift_cluster.redshift_cluster.master_username
    password = random_password.redshift_password.result
    host     = aws_redshift_cluster.redshift_cluster.endpoint
    port     = 5439
    dbname   = aws_redshift_cluster.redshift_cluster.database_name
  })
}