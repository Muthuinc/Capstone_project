#! /bin/bash


terraform init && terraform apply --auto-approve

echo " success"

sleep 5  # this time is usefull for the instance to start up 


a=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Env,Values=prod" --query 'Reservations[].Instances[].PublicIpAddress' --output text)

echo "$a"

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" docker-compose.yml "$ubuntu"@$a:/home/ubuntu

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$ubuntu"@$a <<EOF

sudo apt update -y 

sudo apt install -y docker.io

sudo apt install curl -y

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


EOF