#!/bin/bash

########################
# ACHE - Stop Crawler  #
# version: 1.0.0       #   
########################

if [ "$#" -ne 1 ]; then
    echo "You need to specify the crawler application."
    echo "Example: ./stop_crawler.sh <your_application>"
    exit 1
fi

CRAWLER_APPLICATION=$1

DOCKER_CONTAINER_NAME=${CRAWLER_APPLICATION}_crawler

if [ "$(sudo docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then
    echo "Stopping the crawler..."
    sudo docker stop ${DOCKER_CONTAINER_NAME}

    # verify stopping
    if [ 0 -eq $? ]; then
        echo "Crawler stopped successfully!"
    else
        echo "Something went wrong, could not stop crawler."
        exit 1
    fi
else
    echo "Crawler not running, therefore cannot be stopped."
    exit 1
fi