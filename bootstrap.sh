#!/usr/bin/env bash

echo "Starting bootstrap process..."

if command -v brew >/dev/null 2>&1; then
    PKG_MANAGER="brew"
    INSTALL_CMD="brew install"
elif command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="apt-get"
    INSTALL_CMD="sudo apt-get install -y"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install -y"
else
    echo "Error: No supported package manager found."
    exit 1
fi


echo "Detected package manager: $PKG_MANAGER"

echo "Installing git..."
$INSTALL_CMD git