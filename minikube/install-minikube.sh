#!/bin/bash

set -xe

echo "Checking if Docker is installed.."

if [ -x "$(command -v docker)" ]; then
    echo "Docker is already installed, skipping.."
else
    # Installing via docs.docker.com - https://docs.docker.com/engine/install/ubuntu/
    echo "Docker needs to be installed, assuming this is a fresh install, running.."
    sudo apt-get update -yy && \
    sudo apt-get install -yy \
        ca-certificates \
        curl \
        gnupg \
        lsb-release && \
    sudo mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get update -yy && \
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -yy
    # Check if docker is available after installation
    if [ -x "$(command -v docker)" ]; then
        echo "Docker has been successfully installed.."
    else
        echo "An issue may have occurred during Docker installation.."
        exit 1
    fi
fi

echo "Installing MiniKube.."

if [[ -z "$USER" ]]; then
    echo "There is no current user set.."
    exit 1
else
    echo "Current user is $USER, this is who will be assigned to the Docker user group to run Minikube.."
    echo "Getting Docker group id.."
    DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
    if [[ -z "$DOCKER_GROUP_ID" ]]; then
        echo "Docker group ID is missing, something went wrong.."
        exit 1
    else
        sudo usermod -a -G docker "$USER"
        CHECK_DOCKER_GROUP_FOR_USER=$(grep /etc/group -e "docker")
        CHECK_SUDO_GROUP_FOR_USER=$(grep /etc/group -e "sudo")

        if grep -q "$USER" <<< "$CHECK_DOCKER_GROUP_FOR_USER" || grep -q "$USER" <<< "$CHECK_SUDO_GROUP_FOR_USER"; then
            echo "$USER is apart of groups to run containers, continuing with installation"
        else
            echo "$USER is not part of groups to run containers, not continuing with installation"
            exit 1
        fi
    fi

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi