#! /bin/bash

# building the docker image in my and tagging it with the latest git commit.

docker build -t muthuinc/reactdev2:"${GIT_COMMIT}" .

echo "success"
