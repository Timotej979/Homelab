#!/bin/bash

# Set the env variables
echo "Setting the environment variables"
source nix.env

# Update the configuration file
echo "Updating the configuration file"
cp ./configuration.nix /etc/nixos/configuration.nix

# Rebuild the system
echo "Rebuilding the system"
sudo -i nixos-rebuild switch