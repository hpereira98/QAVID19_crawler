#!/bin/bash

#############################
# ACHE installation script  #
# version: 1.0.0            #   
#############################

# Dependency verification
echo "Verifying dependencies..."
if command -v java >/dev/null 2>&1 ; then
    JAVA_VER="$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)"
    if [[ ${JAVA_VER} -ge 8 ]]
    then
        echo "Java: OK"
        echo "Version: $JAVA_VER"
    else 
        echo "Java: NOT OK"
        echo "Version: $JAVA_VER"
        echo "Required Version: JDK 8 or latest"
        exit 1
    fi
else
    echo "Java: NOT FOUND"
    echo "Required Version: JDK 8 or latest"
    exit 1
fi

if command -v docker >/dev/null 2>&1 ; then
    echo "Docker: OK"
else
    echo "Docker: NOT FOUND"
    exit 1
fi

# Installation
echo ""
echo "Installing ACHE..."

# install docker container
sudo docker run -p 8080:8080 vidanyu/ache:latest

# verify installation
if [ 0 -eq $? ]; then
    echo "ACHE was installed successfully via Docker"
else
    echo "Could not install ACHE"
    exit 1
fi