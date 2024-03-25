resource "aws_db_subnet_group" "rds" {
  name = "ext_feed_rds_group"

  subnet_ids = [
    "${aws_subnet.data_feeds.id}",
    "${aws_subnet.data_feeds_az2.id}",
  ]

  tags {
    Name = "rds-subnet-group-${local.naming_suffix}"
  }
}

resource "random_string" "datafeed_password" {
  length  = 16
  special = false
}

resource "random_string" "datafeed_username" {
  length  = 8
  special = false
  number  = false
}

resource "aws_ssm_parameter" "rds_datafeed_username" {
  name  = "rds_datafeed_username"
  type  = "SecureString"
  value = "${random_string.datafeed_username.result}"
}

resource "aws_ssm_parameter" "rds_datafeed_password" {
  name  = "rds_datafeed_password"
  type  = "SecureString"
  value = "${random_string.datafeed_password.result}"
}

resource "aws_db_instance" "datafeed_rds" {
  identifier              = "postgres-${local.naming_suffix}"
  allocated_storage       = 100
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "12.18"
  instance_class          = "db.m4.large"
  username                = "${random_string.datafeed_username.result}"
  password                = "${random_string.datafeed_password.result}"
  name                    = "${var.datafeed_rds_db_name}"
  backup_window           = "00:00-01:00"
  maintenance_window      = "mon:01:30-mon:02:30"
  backup_retention_period = 14
  storage_encrypted       = true
  multi_az                = true
  skip_final_snapshot     = true

  db_subnet_group_name   = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids = ["${aws_security_group.df_db.id}"]

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "postgres-${local.naming_suffix}"
  }
}

resource "aws_security_group" "df_db" {
  vpc_id = "${var.appsvpc_id}"

  tags {
    Name = "sg-db-${local.naming_suffix}"
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "${var.data_pipe_apps_cidr_block}",
      "${var.opssubnet_cidr_block}",
      "${var.data_feeds_cidr_block}",
      "${var.peering_cidr_block}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_subnet" "data_feeds_az2" {
  vpc_id                  = "${var.appsvpc_id}"
  cidr_block              = "${var.data_feeds_cidr_block_az2}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az2}"

  tags {
    Name = "az2-subnet-${local.naming_suffix}"
  }
}

resource "aws_route_table_association" "data_feeds_rt_rds" {
  subnet_id      = "${aws_subnet.data_feeds_az2.id}"
  route_table_id = "${var.route_table_id}"
}
