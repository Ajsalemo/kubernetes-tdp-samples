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

echo "Continuing with installation.."

if [[ -z "$USER" ]]; then
    echo "There is no current user set.."
    exit 1
else
    

    if [ -x "$(command -v minikube)" ]; then
        echo "Minikube is already installed, skipping.."
    else
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
        if [ -x "$(command -v minikube)" ]; then
            echo "Minikube has been successfully installed.."
            echo "Current user is $USER, this is who will be assigned to the Docker user group to run Minikube.."
            sudo usermod -aG docker $USER && \
            # newgrp creates a sub shell which will cause all subsequent commands to be ran in the new group
            newgrp docker 
            echo "Installation done."
        else
            echo "An issue may have occurred during Minikube installation.."
            exit 1
        fi
    fi
fi
