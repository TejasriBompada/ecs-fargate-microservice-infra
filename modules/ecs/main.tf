resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-${var.env}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
