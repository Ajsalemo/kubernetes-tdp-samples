# kubernetes-tdp-samples - nginx

## How to deploy

- This file includes both a Deployment and Service split up into respective files.
- `nginx.deployment.yaml` contains the Deployment while `nginx.service.yaml` contains the Service.
- **To deploy this, run**:
   ```bash
   kubectl apply -f nginx.deployment.yaml
   kubectl apply -f nginx.service.yaml
   ```` 
- You should now be able to view the NGINX default page over localhost:31321 - the nodePort 



[Use the Kubernetes command cheat sheet.](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources)