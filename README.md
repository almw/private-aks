# Private-AKS Setup and Deployment

## Install CLI Tools

1. **Install Azure CLI:**
    ```pwsl
    winget install --exact --id Microsoft.AzureCLI
2. **Install Terraform:**
    ```pwsl
    winget install --id Hashicorp.Terraform -e
3. **Download kubectl:**
    ```pwsl
    curl.exe -LO "https://dl.k8s.io/release/v1.34.0/bin/windows/amd64/kubectl.exe"

## Azure Subscription

1. **Log out of the Azure account (if logged in):**
    ```pwsl
    az logout

2. **Log in using device code authentication:**
    ```pwsl
    az login --use-device-code

## Terraform Setup
1. **Create a "secrets.tfvars" file with the following content:**
    ```pwsl
    subscription_id = "<Your subscription_id>"
    admin_username  = "<Your VM local admin_username>"
    admin_password  = "<Your VM admin_password>"

2. **Initialize Terraform:**
    ```pwsl
    terraform init

3. **Plan the deployment:**
    ```pwsl
    terraform plan -var-file="secrets.tfvars"

4. **Apply the changes:**
    ```pwsl
    terraform apply -var-file="secrets.tfvars" -auto-approve

5. **Destroy the deployment (if needed):**
    ```pwsl
    terraform destroy -var-file="secrets.tfvars" -auto-approve

## AKS (Azure Kubernetes Service)

1. **Retrieve AKS credentials from a machine with access to the private AKS cluster:**
    ```pwsl
    az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --admin

## Deploy Sample Resources**

1. **Create the namespace:**
    ```pwsl
    kubectl apply -f demo-web/namespace.yaml

2. **Deploy the sample web app (Nginx):**
    ```pwsl
kubectl apply -f demo-web/deployment.yaml

3. **Expose the app internally using a private load balancer (ILB):**
    ```pwsl
    kubectl apply -f demo-web/service-ilb.yaml

4. **Check the deployed service’s external IP and port:**
    ```pwsl
    kubectl get svc -n demo

5. **Access the website via the internal load balancer's IP:**
    ```pwsl
    curl http://<ILB-IP> 
    # or
    Start-Process -FilePath "http://172.16.0.7:80/"


## Create Private Link Service (PLS) & Private Endpoint

```txt
[AKS Pod]  
    ↓  
[AKS Service Type: LoadBalancer → Internal Load Balancer (ILB) External IP]  
    ↓  
[Private Link Service (PLS)]  
    ↓  
[Private Endpoint in VNet 192.168.0.0/24]  
    ↓  
[Client VNet] 