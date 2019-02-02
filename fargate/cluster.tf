# Cluster

resource "aws_ecs_cluster" "main" {
  name = "${local.cluster_name}"

  # Tags
  tags = "${merge(
    var.default_tags, 
    map(
      "Name", "${local.cluster_name}",
      "Workspace", "${terraform.workspace}"
    )
  )}"
}
