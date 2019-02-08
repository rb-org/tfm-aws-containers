[
  {
    "name": "${task_name}",
    "image": "${image_url}",
    "essential": true,
    "workingDirectory": "/usr/src/flaskapi",
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port}
      }
    ],
    "logConfiguration": { 
      "logDriver": "awslogs",
      "options": { 
          "awslogs-group" : "${log_group}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "${log_stream_name}"
      }
    },
    "environment": [
        {
          "name": "db_address",
          "value": "${db_endpoint}"
        },
        {
          "name": "db_database",
          "value": "${database}"
        },
        {
          "name": "db_password",
          "value": "${password}"
        },
        {
          "name": "db_port",
          "value": "${port}"
        },
        {
          "name": "db_user",
          "value": "${user}"
        }
      ]
    
  }
]