#!/usr/bin/env bash

# Installation script for gac (Git AI Commit)
# This script will install gac to ~/bin

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing gac...${NC}"

# Create ~/bin if it doesn't exist
if [[ ! -d "$HOME/bin" ]]; then
    echo "Creating ~/bin directory..."
    mkdir -p "$HOME/bin"
fi

# Copy the script
echo "Copying gac to ~/bin..."
cp gac "$HOME/bin/gac"
chmod +x "$HOME/bin/gac"

# Create config directory
if [[ ! -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config"
fi

# Copy config if it doesn't exist
if [[ ! -f "$HOME/.config/gac.conf" ]]; then
    echo "Creating default configuration file..."
    cp gac.conf.example "$HOME/.config/gac.conf"
    echo -e "${GREEN} Configuration file created at ~/.config/gac.conf${NC}"
    echo "   Please edit this file to add your API credentials."
else
    echo "Configuration file already exists, skipping..."
fi

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo ""
    echo -e "${BLUE}Note: ~/bin is not in your PATH${NC}"
    echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
    echo ""
    echo "    export PATH=\"\$HOME/bin:\$PATH\""
    echo ""
fi

echo ""
echo -e "${GREEN} Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit ~/.config/gac.conf to add your API credentials"
echo "2. Run 'gac -h' to see usage instructions"
echo "3. In any git repository, stage your changes and run 'gac'"
