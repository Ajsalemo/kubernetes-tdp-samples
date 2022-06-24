## Follow the below steps to run containers on a Minikube Cluster with a Azure Linux Virtual Machine

1. Create an Azure Linux Virtual Machine
    For Image select Ubuntu 20.04 LTS - Gen2
    For Size select Standard_D2s_v3 - 2 vcpus (Minikube will not run on a Virtual Machine with less than 2 vCPU)

2. Install Docker on the Virtual Machine - follow [this documentation](https://docs.docker.com/engine/install/ubuntu/) for installation.

3. Install Minikube on the Virtual Machine - follow [this documentation](https://minikube.sigs.k8s.io/docs/start/) for installation. 

4. Start Minikube with `minikube start`
> **NOTE**: If you get an error showing "dial unix /var/run/docker.sock: connect: permission denied", review the error message as you may have to run "sudo usermod -aG docker $USER && newgrp docker". After this, try to start Minikube again.

5. After Minikube is started, clone this repository to the machine. Build the Dockerfile within the repository and push the image to your Azure Container Registry

6. Create a new Service Principal or use an existing Service Principal to create a Kubernetes Pull Secret for your Azure Container Registry.
        a. [New Service Principal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes#create-a-service-principal)
        b. [Existing Service Principal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes#use-an-existing-service-principal)

7. Create an [Image Pull Secret](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes#create-an-image-pull-secret) - name it `minikubesecret`
> **NOTE:** If you do not have kubectl installed, you can use minikube to run the command in the form of - 

```md
minikube kubectl -- create secret docker-registry <secret-name> \
--namespace <namespace> \
--docker-server=<container-registry-name>.azurecr.io \
--docker-username=<service-principal-ID> \
--docker-password=<service-principal-password>
```

8. Review the Pull Secret in `/minikube/minikube-files/nodejs.deploy.yaml`. If your Secret name differs from what is in here, update the .yaml to reflect this.

9. Create the Service with `minikube kubectl -- apply -f nodejs.service.yaml`

10. Create the Deployment with `minikube kubectl -- apply -f nodejs.deploy.yaml`
> **NOTE:** You can run commands like minikube kubectl -- get pods or minikube kubectl -- get services to validate the objects have been deployed.
    If the Pod is in a state other than "Running" use the `kubectl -- get pods` command to find the pod name, and then `minikube kubectl -- describe pods/yourpodname-123-aa`

11. Once the Pod is confirmed to be running, get the exposed minikube service IP with minikube service list

12. Lastly, cURL the application with http://xxx.xx.xx.x:31312 - 31312 being the NodePort set in `nodejs.service.yaml`. cURL'ing http://xxx.xx.xx.x:31312/api/cores should output the number of cores on the machine.