#!/usr/bin/env bash
# Create resource group, ACR, and a VM for Jenkins
set -euo pipefail
AZ_RG=${AZ_RG:-ohs-rg}
AZ_LOCATION=${AZ_LOCATION:-northeurope}
ACR_NAME=${ACR_NAME:-ohsacr$((RANDOM%10000))}
VM_NAME=${VM_NAME:-jenkins-vm}
VM_ADMIN=${VM_ADMIN:-azureuser}
SSH_KEY=${SSH_KEY:-~/.ssh/id_rsa.pub}

echo "Creating resource group $AZ_RG in $AZ_LOCATION"
az group create --name "$AZ_RG" --location "$AZ_LOCATION"

echo "Creating ACR: $ACR_NAME"
az acr create --resource-group "$AZ_RG" --name "$ACR_NAME" --sku Standard --admin-enabled true

# Create VM
echo "Creating VM $VM_NAME"
az vm create   --resource-group "$AZ_RG"   --name "$VM_NAME"   --image UbuntuLTS   --admin-username "$VM_ADMIN"   --generate-ssh-keys   --public-ip-sku Standard

# Output useful info
ACR_LOGIN_SERVER=$(az acr show -n "$ACR_NAME" -g "$AZ_RG" --query loginServer -o tsv)
az acr credential show -n "$ACR_NAME" -g "$AZ_RG"

echo "ACR: $ACR_NAME => $ACR_LOGIN_SERVER"
echo "Use the setup-jenkins-ubuntu.sh script to install Jenkins on the VM."
