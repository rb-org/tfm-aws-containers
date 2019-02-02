[
  {
    "name": "${task_name}",
    "image": "${image_url}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port}
      }
    ]
  }
]