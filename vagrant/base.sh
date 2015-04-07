#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Turn on multiverse repositories
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo sed -i "s/# deb \(.*\) multiverse/deb \1 multiverse/" /etc/apt/sources.list

# Update
sudo apt-get update

# Install base packages
# -qq implies -y --force-yes
sudo apt-get install -qq curl unzip git-core build-essential