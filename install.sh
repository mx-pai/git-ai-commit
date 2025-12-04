#!/usr/bin/env bash

# Installation script for gac (Git AI Commit)
# Usage: ./install.sh [uninstall]
# Author: mx-pai
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.config"
FISH_FUNCTIONS_DIR="$HOME/.config/fish/functions"

install() {
    echo -e "${BLUE}Installing gac...${NC}"

    # Create ~/bin if it doesn't exist
    if [[ ! -d "$BIN_DIR" ]]; then
        echo "Creating $BIN_DIR directory..."
        mkdir -p "$BIN_DIR"
    fi

    # Copy the script
    echo "Copying gac to $BIN_DIR..."
    cp gac "$BIN_DIR/gac"
    chmod +x "$BIN_DIR/gac"

    # Install cmt for fish if fish config exists
    if [[ -d "$FISH_FUNCTIONS_DIR" ]]; then
        echo "Detected fish shell configuration."
        echo "Installing cmt function to $FISH_FUNCTIONS_DIR..."
        cp cmt.fish "$FISH_FUNCTIONS_DIR/cmt.fish"
    fi

    # Create config directory
    if [[ ! -d "$CONFIG_DIR" ]]; then
        mkdir -p "$CONFIG_DIR"
    fi

    # Copy config if it doesn't exist
    if [[ ! -f "$CONFIG_DIR/gac.conf" ]]; then
        echo "Creating default configuration file..."
        cp gac.conf.example "$CONFIG_DIR/gac.conf"
        echo -e "${GREEN} Configuration file created at $CONFIG_DIR/gac.conf${NC}"
        echo "   Please edit this file to add your API credentials."
    else
        echo "Configuration file already exists, skipping..."
    fi

    # Check if ~/bin is in PATH
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo ""
        echo -e "${BLUE}Note: $BIN_DIR is not in your PATH${NC}"
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
    if [[ -d "$FISH_FUNCTIONS_DIR" ]]; then
        echo "4. Use 'cmt' command to add all changes and commit (Fish shell only)"
    fi
}

uninstall() {
    echo -e "${BLUE}Uninstalling gac...${NC}"

    if [[ -f "$BIN_DIR/gac" ]]; then
        rm "$BIN_DIR/gac"
        echo "Removed $BIN_DIR/gac"
    fi

    if [[ -f "$FISH_FUNCTIONS_DIR/cmt.fish" ]]; then
        rm "$FISH_FUNCTIONS_DIR/cmt.fish"
        echo "Removed $FISH_FUNCTIONS_DIR/cmt.fish"
    fi

    echo -e "${GREEN}Uninstallation complete.${NC}"
    echo -e "${BLUE}Note: Configuration file at $CONFIG_DIR/gac.conf was NOT removed.${NC}"
}

# Main
if [[ "${1:-}" == "uninstall" ]]; then
    uninstall
else
    install
fi
