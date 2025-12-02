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
Client in East VNet
In AKS VNet (172.16.0.0/26)
 - AKS using Azure CNI
AKS Service exposed via internal load balancer
Create Private Link Service targeting the AKS ILB
Enable PLS network policies on the subnet (Microsoft.Network/allowPLSBinder)


echo "# private-aks" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/almw/private-aks.git
git push -u origin main
#>
echo "# private-aks" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/almw/private-aks.git
git push -u origin main

git remote add origin https://github.com/almw/private-aks.git
git branch -M main
git push -u origin main