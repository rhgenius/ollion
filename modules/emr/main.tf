# EMR Cluster
resource "aws_emr_cluster" "cluster" {
  name          = "${var.project_name}-${var.environment}-emr-cluster"
  release_label = var.release_label
  applications  = var.applications

  ec2_attributes {
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group = aws_security_group.emr_master.id
    emr_managed_slave_security_group  = aws_security_group.emr_slave.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }

  master_instance_group {
    instance_type = var.master_instance_type
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count

    ebs_config {
      size                 = var.ebs_size
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  tags = {
    Name        = "${var.project_name}-emr-cluster"
    Environment = var.environment
  }

  service_role = aws_iam_role.emr_service_role.arn
  
  log_uri      = "s3://${var.log_bucket}/emr-logs/"
  
  configurations_json = <<EOF
  [
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "SPARK_HISTORY_OPTS": "-Dspark.history.ui.port=18080 -Dspark.history.fs.logDirectory=s3://${var.log_bucket}/spark-history/ -Dspark.history.fs.cleaner.enabled=true"
          }
        }
      ]
    }
  ]
EOF
}

# Security Group for EMR Master
resource "aws_security_group" "emr_master" {
  name        = "${var.project_name}-${var.environment}-emr-master"
  description = "Security group for EMR master"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-emr-master-sg"
    Environment = var.environment
  }
}

# Security Group for EMR Slave
resource "aws_security_group" "emr_slave" {
  name        = "${var.project_name}-${var.environment}-emr-slave"
  description = "Security group for EMR slave"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-emr-slave-sg"
    Environment = var.environment
  }
}

# IAM Role for EMR Service
resource "aws_iam_role" "emr_service_role" {
  name = "${var.project_name}-${var.environment}-emr-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for EMR EC2 Instance Profile
resource "aws_iam_role" "emr_ec2_role" {
  name = "${var.project_name}-${var.environment}-emr-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Instance Profile for EMR
resource "aws_iam_instance_profile" "emr_profile" {
  name = "${var.project_name}-${var.environment}-emr-profile"
  role = aws_iam_role.emr_ec2_role.name
}

# Attach policies to EMR service role
resource "aws_iam_role_policy_attachment" "emr_service_policy" {
  role       = aws_iam_role.emr_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

# Attach policies to EMR EC2 role
resource "aws_iam_role_policy_attachment" "emr_ec2_policy" {
  role       = aws_iam_role.emr_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

# S3 access policy for EMR
resource "aws_iam_role_policy" "emr_s3_access" {
  name = "${var.project_name}-${var.environment}-emr-s3-access"
  role = aws_iam_role.emr_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.log_bucket}",
          "arn:aws:s3:::${var.log_bucket}/*",
          "arn:aws:s3:::${var.data_bucket}",
          "arn:aws:s3:::${var.data_bucket}/*"
        ]
      }
    ]
  })
}