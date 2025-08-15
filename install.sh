#!/bin/bash

# Exit immediately if a command fails
set -e

# Function to run on error
trap 'echo -e "\033[1m\033[31mBLUEPRINT INSTALL UNSUCCESSFUL\033[0m"; exit 1' ERR

# Print bold header
echo -e "\033[1mBLUEPRINT SCRIPT - ITSAHMEDOG\033[0m"

# Change to pterodactyl directory
cd /var/www/pterodactyl || { echo "Directory not found!"; exit 1; }

# Install dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg jq zip unzip git wget

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

# Get latest BlueprintFramework release ZIP URL
ZIP_URL=$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest \
  | jq -r '.assets[]?.browser_download_url' | grep -i '\.zip$' | head -n 1)

if [[ -z "$ZIP_URL" ]]; then
    echo -e "\033[1m\033[31mERROR: Could not find a release ZIP file.\033[0m"
    exit 1
fi

# Download and unzip the release
wget "$ZIP_URL" -O release.zip
unzip -o release.zip
rm release.zip

# Create .blueprintrc file with configuration
sudo bash -c 'cat > /var/www/pterodactyl/.blueprintrc <<EOL
WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";
EOL'

# FINALIZING STUFF
chmod +x blueprint.sh
bash blueprint.sh

# Success message
echo -e "\033[1m\033[32mBLUEPRINT INSTALLED SUCCESSFULLY\033[0m"
echo
echo -e "THANKS FOR USING OUR SCRIPT !"
echo -e "FOR ANY QUERIES CONTACT ON : \033[1mrealahmed1001@gmail.com\033[0m"
echo -e "GIVE 5 STAR ON GITHUB !"
