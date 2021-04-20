#!/bin/bash

########################
# ACHE - Start Crawler #
# version: 1.0.0       #   
########################

if [ "$#" -ne 1 ]; then
    echo "You need to specify the crawler application."
    echo "Example: ./start_crawler.sh <your_application>"
    exit 1
fi

CRAWLER_APPLICATION=$1

ENV_FILE=../configs/${CRAWLER_APPLICATION}/settings.env

if [ ! -f ${ENV_FILE} ]; then
    echo "Environment variables file not found..."
    echo "Please add a 'settings.env' to: ../configs/${CRAWLER_APPLICATION}/"
    echo "Every required variable in 'settings.env_sample' needs to be set or the application won't function properly."
    exit 1
fi

# load environment variables
echo "Loading variables from: ${ENV_FILE} ..."
. ${ENV_FILE}

# local vars
CONFIGS_FOLDER=${ROOT_FOLDER}/configs/${CRAWLER_APPLICATION}
DATA_FOLDER=${ROOT_FOLDER}/data/${CRAWLER_APPLICATION}
DOCKER_CONTAINER_NAME=${CRAWLER_APPLICATION}_crawler


# log folders
echo ""
echo "CONFIGS_FOLDER: ${CONFIGS_FOLDER}"
echo "DATA_FOLDER: ${DATA_FOLDER}"
echo "DOCKER_CONTAINER_NAME: ${DOCKER_CONTAINER_NAME}"

# start crawler
echo ""
if [ "$(sudo docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then
    echo "Crawler is already running."
    echo "Redirecting to Monitoring Tool... (http://0.0.0.0:8080/)"
    nohup xdg-open http://0.0.0.0:8080/ &>/dev/null &
    exit 1
fi
echo "Starting the Crawler..."
nohup sudo docker run \
    -v ${CONFIGS_FOLDER}:/configs/${CRAWLER_APPLICATION} \
    -v ${DATA_FOLDER}:/data/${CRAWLER_APPLICATION} \
    -p 8080:8080 \
    --name ${DOCKER_CONTAINER_NAME} \
    vidanyu/ache startCrawl \
    -c /configs/${CRAWLER_APPLICATION}/ \
    -s /configs/${CRAWLER_APPLICATION}/seeds.txt \
    -o /data/${CRAWLER_APPLICATION}/ \
    &>${OUTPUT_LOG_FILE} &

# wait 60 seconds before checking if it is running
echo ""
echo "COFFEE TIME! The process will now wait 60 seconds before validating if all went well."
sleep 60

# check if it is running
echo ""
if [ ! "$(sudo docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then
    echo "Something went wrong, crawler is not running."
    if [ "$(sudo docker ps -aq -f status=exited -f name=${DOCKER_CONTAINER_NAME})" ]; then
        # container exited
        echo "Docker container named '${DOCKER_CONTAINER_NAME}' already exists."
        echo "Removing Docker container..."
        sudo docker rm ${DOCKER_CONTAINER_NAME}
        echo "Please, try to start the crawler again."
    else
        echo "To identify the error, please check the logs in ${OUTPUT_LOG_FILE}."
        echo "After fixing it, you can try to start the crawler again."
    fi
    exit 1
fi

echo "SUCCESS: Crawler is running!"

# redirect to monitoring server
echo ""
echo "Redirecting to Monitoring Tool... (http://0.0.0.0:8080/)"
nohup xdg-open http://0.0.0.0:8080/ &>/dev/null &