# Outputs

output "ecs_role_arn" {
  value = "${aws_iam_role.ecs_role.arn}"
}

output "ecs_instance_profile_name" {
  value = "${aws_iam_instance_profile.ecs_role_instance_profile.name}"
}
