output "instance_id" {
  value = aws_instance.bastion.id
}

output "private_ip" {
  value = aws_instance.bastion.private_ip
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.profile.arn
}
