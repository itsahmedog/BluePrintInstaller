#!/bin/bash

# =========================================
#  © ITSAHMEDOG - 2025
# =========================================

echo ""
echo -e "\e[1m    █████   ██   ██ ███   ███ █████  \e[0m"
echo -e "\e[1m   ██   ██  ██   ██ ████ ████ ██   ██ \e[0m"
echo -e "\e[1m   ███████  ██   ██ ██ ████ ██ ███████ \e[0m"
echo -e "\e[1m   ██   ██  ██   ██ ██  ██  ██ ██   ██ \e[0m"
echo -e "\e[1m   ██   ██   █████  ██      ██ ██   ██ \e[0m"
echo ""

# Update system and install required dependencies
echo -e "\e[1mUpdating system and installing required dependencies...  \e[0m"
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg unzip

# Create the keyring directory if it doesn't exist
echo -e "\e[1mCreating keyring directory...  \e[0m"
sudo mkdir -p /etc/apt/keyrings 

# Add NodeSource GPG key
echo -e "\e[1mAdding NodeSource GPG key...  \e[0m"
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg 

# Add Node.js 20.x repository
echo -e "\e[1mAdding Node.js 20.x repository...  \e[0m"
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list 

# Update package lists
echo -e "\e[1mUpdating package lists...  \e[0m"
sudo apt-get update 

# Install Node.js
echo -e "\e[1mInstalling Node.js...  \e[0m"
sudo apt-get install -y nodejs 

# Install Yarn globally
echo -e "\e[1mInstalling Yarn...  \e[0m"
npm i -g yarn 

# Change to Pterodactyl directory
echo -e "\e[1mNavigating to Pterodactyl directory...  \e[0m"
cd /var/www/pterodactyl || { echo -e "\e[1mPterodactyl directory not found! Exiting...  \e[0m"; exit 1; }

# Install dependencies using Yarn
echo -e "\e[1mInstalling project dependencies...  \e[0m"
yarn 

# Download the latest Blueprint Framework release
echo -e "\e[1mDownloading latest Blueprint Framework release...  \e[0m"
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip

# Unzip the release
echo -e "\e[1mExtracting files...  \e[0m"
unzip release.zip 

# Create .blueprintrc configuration file
echo -e "\e[1mCreating .blueprintrc file...  \e[0m"
touch /var/www/pterodactyl/.blueprintrc 

# Add configuration to .blueprintrc
echo -e "\e[1mAdding configuration to .blueprintrc...  \e[0m"
echo 'WEBUSER="www-data"; OWNERSHIP="www-data:www-data"; USERSHELL="/bin/bash";' | sudo tee /var/www/pterodactyl/.blueprintrc 

# Ensure blueprint.sh is executable
echo -e "\e[1mSetting executable permissions for blueprint.sh...  \e[0m"
chmod +x blueprint.sh 

# Run blueprint.sh
echo -e "\e[1mExecuting blueprint.sh...  \e[0m"
bash blueprint.sh 

# Set full permissions for Pterodactyl directory
echo -e "\e[1mSetting full permissions for /var/www/pterodactyl...  \e[0m"
sudo chmod -R 777 /var/www/pterodactyl

# =========================================
#  © ITSAHMEDOG - 2025
# =========================================

echo ""
echo -e "\e[1m--------------------------------------------\e[0m"
echo -e "\e[1m  ✅ INSTALLED BLUEPRINT SUCCESSFULLY!  \e[0m"
echo -e "\e[1m  ✅ YOU CAN NOW INSTALL EXTENSIONS!  \e[0m"
echo -e "\e[1m--------------------------------------------\e[0m"
echo ""

