# Outputs

output "id" {
  value = "${aws_ecs_cluster.main.id}"
}

output "name" {
  value = "${aws_ecs_cluster.main.name}"
}

output "log_group_name" {
  value = "${aws_cloudwatch_log_group.main.name}"
}
