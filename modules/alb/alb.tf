resource "aws_lb" "application_lb" {
  name               = "pearl-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups = var.sgID
  ip_address_type = "ipv4"
#   access_logs {
#     enabled = "false"
#     # bucket  = module.s3_bucket.bucket_id
#     # prefix  = ""
#   }
  idle_timeout               = "300"
  enable_deletion_protection = "false"
  enable_http2               = "true"

}


resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target_group_1.arn
    type             = "forward"
  }
}