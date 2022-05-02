resource "aws_lb" "main" {
  name                       = "${var.environment}-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.alb_security_groups
  subnets                    = var.subnets.*.id
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "main" {
  name        = "${var.environment}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port = "80"
  protocol = "HTTP"

  # forward port 80 (for real we'd redirect to 443 with a cert)
  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}