#!/bin/bash

# Update system and install required dependencies
echo "Updating system and installing required dependencies..."
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg unzip

# Create the keyring directory if it doesn't exist
sudo mkdir -p /etc/apt/keyrings 

# Add NodeSource GPG key
echo "Adding NodeSource GPG key..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg 

# Add Node.js 20.x repository
echo "Adding Node.js 20.x repository..."
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list 

# Update package lists
echo "Updating package lists..."
sudo apt-get update 

# Install Node.js
echo "Installing Node.js..."
sudo apt-get install -y nodejs 

# Install Yarn globally
echo "Installing Yarn..."
npm i -g yarn 

# Change to Pterodactyl directory
cd /var/www/pterodactyl || { echo "Pterodactyl directory not found!"; exit 1; }

# Install dependencies using Yarn
echo "Installing project dependencies..."
yarn 

# Download the latest Blueprint Framework release
echo "Downloading latest Blueprint Framework release..."
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip

# Unzip the release
echo "Extracting files..."
unzip release.zip 

# Create .blueprintrc configuration file
echo "Creating .blueprintrc file..."
touch /var/www/pterodactyl/.blueprintrc 

# Add configuration to .blueprintrc
echo 'WEBUSER="www-data"; OWNERSHIP="www-data:www-data"; USERSHELL="/bin/bash";' | sudo tee /var/www/pterodactyl/.blueprintrc 

# Ensure blueprint.sh is executable
echo "Setting permissions for blueprint.sh..."
chmod +x blueprint.sh 

# Run blueprint.sh
echo "Executing blueprint.sh..."
bash blueprint.sh 

echo "Installation and setup completed successfully!"
