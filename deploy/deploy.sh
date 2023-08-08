#! /bin/bash

a=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Env,Values=dev" --query 'Reservations[].Instances[].PublicIpAddress' --output text)
# getting the ip address of the dev instance
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$ubuntu"@$a <<EOF

sudo docker rm -f $(sudo docker ps -q --filter name=muthu) 

sudo docker rmi $(sudo docker images -q --filter reference=muthuinc/reactdev2)

sudo GIT_COMMIT=$GIT_COMMIT docker-compose up -d


if curl localhost:80
then
  echo "success"
fi

EOF
