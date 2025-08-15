#!/bin/bash

# Exit immediately if a command fails
set -e

# Print bold header
echo -e "\033[1mBLUEPRINT SCRIPT - ITSAHMEDOG\033[0m"

# Function to run on error
trap 'echo -e "\033[1m\033[31mBLUEPRINT INSTALL UNSUCCESSFUL\033[0m"; exit 1' ERR

# Change to pterodactyl directory
cd /var/www/pterodactyl || { echo "Directory not found!"; exit 1; }

# Install dependencies
sudo apt-get install -y ca-certificates curl gnupg

# Create directory for keyrings
sudo mkdir -p /etc/apt/keyrings

# Add NodeSource GPG key
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Add NodeSource repository
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
  | sudo tee /etc/apt/sources.list.d/nodesource.list

# Update package list
sudo apt-get update

# Install Node.js
sudo apt-get install -y nodejs

# Install yarn globally
sudo npm i -g yarn

# Install project dependencies
yarn

# Install other useful tools
sudo apt install -y zip unzip git curl wget

# Download latest BlueprintFramework release
sudo wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip

# Unzip the release
unzip release.zip

# Create .blueprintrc file
sudo touch /var/www/pterodactyl/.blueprintrc

# Add configuration to .blueprintrc
sudo bash -c 'echo \
"WEBUSER=\"www-data\";
OWNERSHIP=\"www-data:www-data\";
USERSHELL=\"/bin/bash\";" >> /var/www/pterodactyl/.blueprintrc'

# Success message
echo -e "\033[1m\033[32mBLUEPRINT INSTALLED SUCCESSFULLY\033[0m"
echo
echo -e "THANKS FOR USING OUR SCRIPT !"
echo -e "FOR ANY QUERIES CONTACT ON : \033[1mrealahmed1001@gmail.com\033[0m"
echo -e "GIVE 5 STAR ON GITHUB !"
