output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "task_definition_arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.this.arn
}

output "service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.this.arn
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.this.name
}

output "execution_role_arn" {
  description = "Execution role ARN for tasks"
  value       = aws_iam_role.ecs_execution.arn
}

output "task_role_arn" {
  description = "Task role ARN (for app permissions)"
  value       = aws_iam_role.ecs_task.arn
}
