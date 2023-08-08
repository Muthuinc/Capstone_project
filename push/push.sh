#! /bin/bash

echo "$DOCKER_CRED_PSW" | docker login -u $DOCKER_CRED_USR --password-stdin

docker push muthuinc/reactdev2:"${GIT_COMMIT}"

docker logout

echo "success"

