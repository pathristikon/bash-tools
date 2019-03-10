#!/bin/bash

docker run --name jupyter --rm -p 10000:8888 -v /c/Users/Alexandru/Documents/work/jupyter:/home/jovyan/work jupyter/scipy-notebook

containerID=$(docker ps | grep jupyter| awk '{print $1}')

echo -e "\nDocker container ID: $containerID"

echo -e "\nLogs are displayed below:"

sleep 2

docker container logs $containerID
