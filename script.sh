#!/bin/bash
set -e # Exit script immediately on error

echo "Installing app dependencies..."

# --- CRITICAL ADDITION 1: Install Docker ---
# Your Jenkinsfile builds and pushes Docker images. Docker must be installed.
# This assumes an Amazon Linux / CentOS-like system. Adjust for Debian/Ubuntu if needed.
echo "Installing Docker..."
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
# Add the 'ec2-user' to the 'docker' group to run docker commands without sudo
sudo usermod -aG docker ec2-user
# For the group change to take effect immediately in the current shell (important for Jenkins)
# This 'newgrp' command temporarily switches the primary group for the current shell.
# If the Jenkins pipeline doesn't seem to recognize the group change, you might need
# to run Docker commands with 'sudo' or ensure the Jenkins user/agent session is properly restarted.
newgrp docker || true # '|| true' to prevent script exit if newgrp fails in non-interactive shell

echo "Docker installed successfully."
docker --version


# Install or Update kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "kubectl installed successfully."
kubectl version --client
# --- MINOR ADDITION 1: Clean up downloaded binary ---
rm kubectl


# --- CRITICAL ADDITION 2: Install AWS CLI ---
# Your Jenkinsfile uses 'aws eks update-kubeconfig', so AWS CLI is required.
echo "Installing AWS CLI..."
# Using the recommended installer for AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update # Use --update to ensure it updates if already present
echo "AWS CLI installed/updated successfully."
aws --version
# Clean up downloaded files
rm -rf awscliv2.zip aws/


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
# --- MINOR ADDITION 2: Clean up downloaded archive ---
rm eksctl_Linux_amd64.tar.gz

echo "All dependencies installed successfully."
