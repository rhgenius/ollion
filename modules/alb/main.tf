# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = true

  access_logs {
    bucket  = var.log_bucket
    prefix  = "alb-logs"
    enabled = var.enable_access_logs
  }

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
  }
}

# Target Group
resource "aws_lb_target_group" "target_group" {
  for_each = var.target_groups

  name        = "${var.project_name}-${var.environment}-${each.key}-tg"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  health_check {
    enabled             = true
    interval            = lookup(each.value, "health_check_interval", 30)
    path                = lookup(each.value, "health_check_path", "/health")
    port                = lookup(each.value, "health_check_port", "traffic-port")
    protocol            = lookup(each.value, "health_check_protocol", each.value.protocol)
    timeout             = lookup(each.value, "health_check_timeout", 5)
    healthy_threshold   = lookup(each.value, "healthy_threshold", 3)
    unhealthy_threshold = lookup(each.value, "unhealthy_threshold", 3)
    matcher             = lookup(each.value, "health_check_matcher", "200-299")
  }

  tags = {
    Name        = "${var.project_name}-${each.key}-tg"
    Environment = var.environment
  }
}

# Listeners
resource "aws_lb_listener" "http" {
  count = var.create_http_listener ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.redirect_http_to_https ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.redirect_http_to_https ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.redirect_http_to_https ? [] : [1]
      content {
        target_group {
          arn = aws_lb_target_group.target_group[var.default_target_group_key].arn
        }
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.create_https_listener ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[var.default_target_group_key].arn
  }
}

# Listener Rules
resource "aws_lb_listener_rule" "rules" {
  for_each = var.create_https_listener ? var.listener_rules : {}

  listener_arn = aws_lb_listener.https[0].arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }
}