output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "availability_zones" {
  value = var.azs
}

# Output list of private route table IDs
output "private_route_table_ids" {
  value       = [for rt in aws_route_table.private : rt.id]
  description = "List of private route table IDs"
}

output "public_route_table_ids" {
  value       = [aws_route_table.public.id]
  description = "List of public route table IDs"
}
