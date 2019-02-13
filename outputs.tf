# Outputs

output "alb_single_tg_arns" {
  value = "${module.alb_single.tg_arns}"
}

output "cluster_id" {
  value = "${module.ecs_cluster.id}"
}
