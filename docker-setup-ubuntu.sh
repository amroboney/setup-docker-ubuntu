#!/bin/bash

# Check if the required parameters are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <github_email> <dockeruser_password>"
    exit 1
fi

GITHUB_EMAIL=$1
DOCKERUSER_PASSWORD=$2

# Step 1: Update the system and install necessary packages
echo "Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git

# Step 2: Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Step 3: Create a new user 'dockeruser'
echo "Creating user 'dockeruser'..."
sudo useradd -m -s /bin/bash dockeruser
echo "dockeruser:$DOCKERUSER_PASSWORD" | sudo chpasswd

# Step 4: Add 'dockeruser' to the Docker group
echo "Adding 'dockeruser' to the Docker group..."
sudo usermod -aG docker dockeruser

# Step 5: Install Docker Compose (optional but useful)
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 6: Generate SSH key for GitHub for 'dockeruser'
echo "Generating SSH key for 'dockeruser'..."
sudo -u dockeruser ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL" -f "/home/dockeruser/.ssh/github" -N ""

# Step 7: Set up SSH config file for 'dockeruser'
echo "Configuring SSH for 'dockeruser'..."
SSH_CONFIG_FILE="/home/dockeruser/.ssh/config"
sudo -u dockeruser bash -c "cat <<EOF > $SSH_CONFIG_FILE
Host github.com
  HostName github.com
  User git
  IdentityFile /home/dockeruser/.ssh/id_rsa
  IdentitiesOnly yes
EOF"

# Set proper permissions for the SSH directory and config file
sudo chmod 700 /home/dockeruser/.ssh
sudo chmod 600 $SSH_CONFIG_FILE
sudo chown -R dockeruser:dockeruser /home/dockeruser/.ssh


# Step 8: Add SSH key to GitHub (display the key for copying)
echo "Your SSH public key for GitHub is:"
cat /home/dockeruser/.ssh/github.pub

echo "Copy the public key above and add it to your GitHub account at: https://github.com/settings/keys"

# Step 9: Test Docker installation and SSH connection (as 'dockeruser')
echo "Testing Docker installation..."
sudo -u dockeruser docker --version

echo "Testing SSH connection to GitHub..."
sudo -u dockeruser ssh -T git@github.com

echo "Setup complete! Please add the SSH key to your GitHub account."
