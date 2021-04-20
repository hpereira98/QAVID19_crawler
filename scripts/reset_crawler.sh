#!/bin/bash

########################
# ACHE - Reset Crawler #
# version: 1.0.0       #   
########################

if [ "$#" -ne 1 ]; then
    echo "You need to specify the crawler application."
    echo "Example: ./stop_crawler.sh <your_application>"
    exit 1
fi

CRAWLER_APPLICATION=$1

DOCKER_CONTAINER_NAME=${CRAWLER_APPLICATION}_crawler

# try to stop crawler
echo "Trying to stop the Crawler..."
./stop_crawler.sh ${CRAWLER_APPLICATION}

# remove crawler container
echo "Trying to remove the Crawler's Docker container..."
sudo docker rm ${DOCKER_CONTAINER_NAME}
if [ 0 -eq $? ]; then
    echo "Crawler's Docker container removed successfully!"
else
    echo "Something went wrong, could not remove container."
    exit 1
fi

# remove crawled data
echo "Deleting crawled data..."
sudo rm -rf ../data/${CRAWLER_APPLICATION}/
if [ 0 -eq $? ]; then
    echo "Crawled data deleted successfully!"
else
    echo "Something went wrong, could not delete data."
    exit 1
fi

echo "Crawler reset with success."