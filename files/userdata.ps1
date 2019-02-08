<powershell>
# Get tags
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Value 1 -Type DWord

$instanceid     = Invoke-RestMethod http://169.254.169.254/latest/meta-data/instance-id # this uses the EC2 instance ID as the node name
$tags           = Get-EC2Instance -Instance $instanceId | Select -ExpandProperty Instances | Select -ExpandProperty Tags
$wkspc          = $tags | ? Key -eq Workspace | Select -ExpandProperty Value
$svrName        = $tags | ? Key -eq MachineName | Select -ExpandProperty Value
$name           = $tags | ? Key -eq Name | Select -ExpandProperty Value
$suffix         = $instanceid.substring($instanceid.length -2,2)


# Install the Cloudwatch Agent 
# This is a temporary solution - Chef should do this
mkdir c:\temp
wget https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip -o "c:\temp\cwagent.zip"
cd c:\temp
expand-archive cwagent.zip
cd cwagent
./install.ps1
cd "C:\Program Files\Amazon\AmazonCloudWatchAgent"
$ssmName = $name -replace ".{3}$"
./amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:/$wkspc/cw_agent/$ssmName -s

# Change the computer Name
Rename-Computer -newname "$svrName$suffix" -Restart -Force

</powershell>
