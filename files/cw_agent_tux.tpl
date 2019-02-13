{
	"agent": {
        "metrics_collection_interval": 15,
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
      },
	"logs": {
    "log_stream_name": "{instance_id}",
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/cron",
						"log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/cron",
            "timezone": "UTC"
					},
					{
						"file_path": "/var/log/opscode/nginx/error.log",
						"log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/nginx",
            "timezone": "UTC"
					},
          {
            "file_path": "/var/log/amazon/ssm/amazon-ssm-agent.log",
            "log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/ssm_agent",
            "timezone": "UTC",
            "timestamp_format":"%H:%M:%S %y %b %-d"
          },
					{
            "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/cw_agent",
            "timezone": "UTC",
            "timestamp_format":"%H:%M:%S %y %b %-d"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/syslog",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/kern.log",
            "log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/kern",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "/${log_prefix}/${instance_name}-log-group",
            "log_stream_name": "{instance_id}/cfn",
            "timezone": "UTC"
          }
				]
			}
		}
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
			"ImageId": "$${aws:ImageId}",
			"InstanceId": "$${aws:InstanceId}",
			"InstanceType": "$${aws:InstanceType}"
		},
    "aggregation_dimensions": [
			["AutoScalingGroupName"],
			["ImageId"], 
			["InstanceId", "InstanceType"], 
			["d1"],
			[]
		],
		"metrics_collected": {
			"cpu": {
				"measurement": [
					"cpu_usage_idle",
					"cpu_usage_user",
					"cpu_usage_system",
          {"name": "cpu_usage_idle", "rename": "CPU_USAGE_IDLE", "unit": "Percent"},
          {"name": "cpu_usage_nice", "unit": "Percent"}
				],
				"metrics_collection_interval": 15,
				"resources": [
					"*"
				],
				"totalcpu": false
			},
			"disk": {
				"measurement": [
          {"name": "free", "rename": "DISK_FREE", "unit": "Gigabytes"},
          "total",
          "used",
					"used_percent"
				],
				"metrics_collection_interval": 15,
        "ignore_file_system_types": [
              "sysfs", "devtmpfs"
            ],
				"resources": [
					"/",
          "/tmp"
				]
			},
			"diskio": {
				"measurement": [
					"io_time",
					"write_bytes",
					"read_bytes",
					"writes",
					"reads"
				],
				"metrics_collection_interval": 15,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
          "mem_used",
          "mem_cached",
          "mem_total",
					"mem_used_percent"
				],
				"metrics_collection_interval": 15
			},
      "net": {
        "resources": [
          "eth0"
        ],
        "measurement": [
          "bytes_sent",
          "bytes_recv",
          "drop_in",
          "drop_out"
        ]
      },
			"netstat": {
				"measurement": [
					"tcp_established",
					"tcp_time_wait",
          "tcp_syn_sent",
          "tcp_close"
				],
				"metrics_collection_interval": 15
			},
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ]
      },
			"swap": {
				"measurement": [
					"swap_used_percent"
				],
				"metrics_collection_interval": 15
			}
		}
	}
}