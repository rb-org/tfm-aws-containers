
#!/bin/bash


# Variables 

LOCAL_IPV4=`curl curl http://169.254.169.254/latest/meta-data/local-ipv4 2> /dev/null`
PUBLIC_DNSNAME=`curl http://169.254.169.254/latest/meta-data/public-hostname 2> /dev/null`
LOCAL_DNSNAME=`curl http://169.254.169.254/latest/meta-data/local-hostname 2> /dev/null`
HOSTNAME=`echo $LOCAL_DNSNAME | cut -d. -f 1`

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
wkspc=$(aws ec2 describe-instances --instance-ids $instance_id --region eu-west-1 --query 'Reservations[*].Instances[*].[Tags[?Key==`Workspace`].Value]' --output text)
name=$(aws ec2 describe-instances --instance-ids $instance_id --region eu-west-1 --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]' --output text)
short_name=$(echo $name| head -c -4)
enable_ecs=$(aws ec2 describe-instances --instance-ids $instance_id --region eu-west-1 --query 'Reservations[*].Instances[*].[Tags[?Key==`AppID`].Value]' --output text)
ecs_cluster_id=${cluster_id}
# Add the local hostname to /etc/hosts
echo "$LOCAL_IPV4 $HOSTNAME $LOCAL_DNSNAME" | sudo tee /etc/hosts

# Update OS and install NTP client
sudo yum update
sudo yum install ntp -y

# Install CloudWatch Unified Agent
install_cw_agent(){
    cd /tmp
    sudo yum install unzip -y
    if [ ! -f AmazonCloudWatchAgent.zip ]; then
      rm AmazonCloudWatchAgent.zip
    fi
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
    unzip AmazonCloudWatchAgent.zip
    sudo ./install.sh

    # echo $CW_CFG >> /tmp/cw_agent_config.json 
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:/$wkspc/cw_agent/$short_name -s
}

ecs_config(){
  if $enable_ecs == 'ecs'; then
    # Set any ECS agent configuration options
    echo "ECS_CLUSTER=$ecs_cluster_id" >> /etc/ecs/ecs.config
  fi
}

install_cw_agent
ecs_config
