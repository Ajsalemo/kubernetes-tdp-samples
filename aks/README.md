## Follow the below steps to run containers on a Azure Kubernetes Cluster

1. Clone this repository, build the Image and push this to your Azure Container Registry. Update the .yaml file under `/aks-python/kubernetes/python.deploy.yaml` to your Container Registry.

2. [Follow this Quickstart](https://docs.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli) to create an Azure Kubernetes Service through the Portal.
  > **Note:** Do not deploy with the [deploy section](https://docs.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli#deploy-the-application) in the Quick Start

3. [Configure the AKS cluster to connect with your Container Registry](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration?toc=%2Fazure%2Fcontainer-registry%2Ftoc.json&bc=%2Fazure%2Fcontainer-registry%2Fbreadcrumb%2Ftoc.json&tabs=azure-cli#configure-acr-integration-for-existing-aks-clusters). You can check connectivity between AKS and ACR with [az aks check-acr](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-check-acr)

4. Deploy the Service and Deployment with the following:
   a. `kubectl apply -f python.service.yaml`
   b. `kubectl apply -f python.deploy.yaml`

5. Use `kubectl get services --watch` and wait for the External IP to populate. Once this is populated, enter this in the browser. Afterwards (this may take a few seconds) the application should be viewable.

    You can view the state of the pods with `kubectl get pods` followed by `kubectl describe pods/<podName>`

6. Browsing to xx.xx.xxx.xx/api/info should show: `"message": "Current CPU core count is: 2. Current OS type is: Linux"`


> **NOTE:** This is designed to run with Gunicorn and the application exposed over port 80. Configuring a port that is not 80 will require additional ingress configuration.
