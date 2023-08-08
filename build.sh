#! /bin/bash

# building the docker image for prod branch

docker build -t muthuinc/reactprod2:"${GIT_COMMIT}" .


echo "success"