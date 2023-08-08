#! /bin/bash

echo "$DOCKER_CRED_PSW" | docker login -u $DOCKER_CRED_USR --password-stdin


docker push muthuinc/reactprod2:"${GIT_COMMIT}" # this is the private repository


docker logout

echo "success"