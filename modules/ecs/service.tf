resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-${var.env}-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  desired_count = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
      assign_public_ip = var.assign_public_ip
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  dynamic "load_balancer" {
    for_each = var.alb_target_group_arn != "" ? [var.alb_target_group_arn] : []
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  depends_on = [  ]
  # optional: if you use an ALB and a target group created outside this module,
  # you can attach the load_balancer block here by passing var.load_balancer (not added now).
  lifecycle {
    ignore_changes = [
      # ignore desired_count changes coming from autoscaling
      desired_count
    ]
  }

  tags = var.tags
}

resource "aws_appautoscaling_target" "ecs" {
  count               = var.enable_autoscaling ? 1 : 0
  max_capacity        = var.max_capacity
  min_capacity        = var.min_capacity
  resource_id         = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension  = "ecs:service:DesiredCount"
  service_namespace   = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_target" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "${var.app_name}-${var.env}-cpu-policy"
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension  = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace   = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target_utilization
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
