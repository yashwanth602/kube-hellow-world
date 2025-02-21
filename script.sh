#!/bin/bash
set -e  # Exit script immediately on error

echo "Installing app dependencies..."

# Install or Update kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "kubectl installed successfully."
kubectl version --client

# Install or Update AWS CLI
echo "Checking AWS CLI installation..."

echo "AWS CLI installed/updated successfully."
aws --version

# Install Helm (Always install latest)
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Helm installed successfully."
helm version

# Install eksctl (Always install latest)
echo "Installing eksctl..."
curl -sSLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf eksctl_Linux_amd64.tar.gz
sudo mv eksctl /usr/local/bin/
echo "eksctl installed successfully."
eksctl version

echo "All dependencies installed successfully."
