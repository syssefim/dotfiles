#!/bin/bash

# Define colors for terminal output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print Welcome Message
echo -e "${BLUE}"
echo "==============================================="
echo "  🚀 Welcome to Serafim's System Bootstrap 🚀  "
echo "==============================================="
echo -e "${NC}"

# Prompt to proceed
echo -e -n "${YELLOW}Do you want to proceed with the installation? [y/N]: ${NC}"
read -r response

# Check if the user typed y or Y
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "\n${RED}Installation aborted by user. No changes were made.${NC}"
    exit 0
fi

echo -e "\n${GREEN}Initializing setup...${NC}\n"

# 1. Helper function to check if a command exists before installing
check_and_install() {
    local check_cmd=$1
    local install_cmd_full=$2
    local display_name=$3

    if command -v "$check_cmd" &> /dev/null; then
        echo -e "${GREEN}✅ $display_name is already installed. Skipping.${NC}"
    else
        echo -e "${YELLOW}📦 Installing $display_name...${NC}"
        eval "$install_cmd_full"
    fi
}

# 2. Detect Operating System
OS="$(uname -s)"
GIT_PKG="git"
NVIM_PKG="neovim"

case "${OS}" in
    Linux*)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO="${ID}"
        else
            echo "Cannot determine Linux distribution."
            exit 1
        fi

        case "${DISTRO}" in
            ubuntu|debian)
                INSTALL_CMD="sudo apt-get install -y"
                PYTHON_PKG="python3"
                PYTHON_CMD="python3"
                CODE_INSTALL="sudo snap install code --classic"
                ;;
            fedora)
                INSTALL_CMD="sudo dnf install -y"
                PYTHON_PKG="python3"
                PYTHON_CMD="python3"
                CODE_INSTALL="sudo dnf install -y code"
                ;;
            arch)
                INSTALL_CMD="sudo pacman -S --noconfirm"
                PYTHON_PKG="python"
                PYTHON_CMD="python"
                
                # Check and install yay (AUR helper) if missing
                if ! command -v yay &> /dev/null; then
                    echo -e "${YELLOW}yay not found. Installing yay...${NC}"
                    sudo pacman -S --noconfirm base-devel git
                    git clone https://aur.archlinux.org/yay.git /tmp/yay
                    cd /tmp/yay || exit
                    makepkg -si --noconfirm
                    cd - || exit
                    rm -rf /tmp/yay
                fi
                CODE_INSTALL="yay -S --noconfirm visual-studio-code-bin"
                ;;
            *)
                echo "Unsupported Linux distro: ${DISTRO}"
                exit 1
                ;;
        esac
        ;;
    Darwin*)
        if ! command -v brew &> /dev/null; then
            echo "Homebrew is required but not installed."
            exit 1
        fi
        INSTALL_CMD="brew install"
        PYTHON_PKG="python"
        PYTHON_CMD="python3" # Homebrew typically maps python to python3
        CODE_INSTALL="brew install --cask visual-studio-code"
        ;;
    *)
        echo "Unsupported OS: ${OS}"
        exit 1
        ;;
esac

# 3. Execute the installations using the helper function
check_and_install "git" "${INSTALL_CMD} ${GIT_PKG}" "Git"
check_and_install "nvim" "${INSTALL_CMD} ${NVIM_PKG}" "Neovim"
check_and_install "${PYTHON_CMD}" "${INSTALL_CMD} ${PYTHON_PKG}" "Python"
check_and_install "code" "${CODE_INSTALL}" "VS Code"

echo -e "\n${GREEN}🎉 Bootstrap complete!${NC}"