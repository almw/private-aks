# Required CLI
winget install --exact --id Microsoft.AzureCLI
winget install --id Hashicorp.Terraform -e

az logout
az login --use-device-code
az account show --query id
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"  -auto-approve
terraform destroy -var-file="secrets.tfvars"  -auto-approve


az aks get-credentials -g <rg-name> -n <aks-name> --admin

# Create Namespace
kubectl apply -f namespace.yaml
# Deploy Sample Web App (Nginx)
kubectl apply -f deployment.yaml
# Expose App Internally (Private ILB)
kubectl apply -f service-ilb.yaml
# Access the Website
curl http://<ILB-IP>


<#
[AKS Pod]  
    ↓  
[AKS Service Type: LoadBalancer → Internal Load Balancer (ILB)]  
    ↓  
[Private Link Service (PLS)]  
    ↓  
[Private Endpoint in VNet 192.168.0.0/24]  
    ↓  
Client in West VNet
In AKS VNet (172.16.0.0/26)
 - AKS using Azure CNI
AKS Service exposed via internal load balancer
Create Private Link Service targeting the AKS ILB
Enable PLS network policies on the subnet (Microsoft.Network/allowPLSBinder)


echo "# private-aks" >> README.md
git init
git add README.md
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/almw/private-aks.git
git push -u origin main

git remote add origin https://github.com/almw/private-aks.git
git branch -M main
git push -u origin main
#>
winget install --exact --id Microsoft.AzureCLI
winget install --id Hashicorp.Terraform -e
az login --use-device-code
az account show --query id
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"  -auto-approve
terraform destroy -var-file="secrets.tfvars"  -auto-approve

curl.exe -LO "https://dl.k8s.io/release/v1.34.0/bin/windows/amd64/kubectl.exe"
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=msi

az aks get-credentials -g <rg-name> -n <aks-name> --admin
az aks get-credentials -g aks-rg -n aksalmwdemocluster101 --admin

kubectl get nodes
kubectl get pods -A

# Create Namespace
kubectl apply -f namespace.yaml
# Deploy Sample Web App (Nginx)
kubectl apply -f deployment.yaml
# Expose App Internally (Private ILB)
kubectl apply -f service-ilb.yaml


kubectl get pods -o wide -n demo
kubectl describe pod demo-web -n demo
kubectl get svc -n demo

# Access the Website
curl http://172.16.0.6 
Start-Process -FilePath "http://172.16.0.6/"

# Deploy Your Web App Behind Internal Load Balancer
kubectl apply -f service-ilb1.yaml
kubectl get svc -n demo
<#
NAME           TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
demo-web       LoadBalancer   10.0.227.198   172.16.0.7    8080:32540/TCP   17s
demo-web-svc   LoadBalancer   10.0.103.142   172.16.0.6    80:30944/TCP     13m
#>
Start-Process -FilePath "http://172.16.0.7:8080/"

EXTERNAL-IP: 172.16.0.7
<#
[AKS Pod]  
    ↓  
[AKS Service Type: LoadBalancer → Internal Load Balancer (ILB)]  
    ↓  
[Private Link Service (PLS)]  
    ↓  
[Private Endpoint in VNet 192.168.0.0/24]  
    ↓  
Client in East VNet
In AKS VNet (172.16.0.0/26)
 - AKS using Azure CNI
AKS Service exposed via internal load balancer
Create Private Link Service targeting the AKS ILB
Enable PLS network policies on the subnet (Microsoft.Network/allowPLSBinder)
#>
