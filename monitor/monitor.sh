#! /bin/bash



a=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Env,Values=dev" --query 'Reservations[].Instances[].PublicIpAddress' --output text)

sed -i "s/EC2_ip/$a/g" prometheus.yml

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" blackbox.yml "$ubuntu"@$a:/home/ubuntu

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" prometheus.yml "$ubuntu"@$a:/home/ubuntu

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" grafana.ini "$ubuntu"@$a:/home/ubuntu

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" docker-compose1.yml "$ubuntu"@$a:/home/ubuntu

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$ubuntu"@$a <<EOF


sudo docker-compose -f docker-compose1.yml up -d


EOF
