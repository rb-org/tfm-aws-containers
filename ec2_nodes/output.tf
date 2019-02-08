output "sg_id" {
  value = "${aws_security_group.sg_ecs.id}"
}

output "sg_name" {
  value = "${aws_security_group.sg_ecs.name}"
}
