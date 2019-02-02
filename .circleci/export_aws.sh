#!/bin/sh
mkdir -p ~/.aws
# echo -e "[ci-global]" > ~/.aws/credentials ci-glbl-auto

# Global Automation 
echo -e "[default]" > ~/.aws/credentials
echo -e "aws_access_key_id = $access_key_ci_xyz_auto" >> ~/.aws/credentials
echo -e "aws_secret_access_key = $secret_key_ci_xyz_auto" >> ~/.aws/credentials
