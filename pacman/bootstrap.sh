#!/bin/bash



# Print Welcome Message
echo "
⣿⠿⠿⠛⠛⠛⠟⠿⠻⣿⣿⡿⠿⠿⠛⠛⠛⠛⠿⢿
⣷⣴⣾⠿⠿⠿⣷⢶⢾⣿⣿⡿⢶⡶⠿⠻⠛⣿⣶⣽
⣿⣿⣏⠶⠀⠀⠭⢺⣺⣿⣿⣧⣺⠧⠄⠀⡰⢛⣽⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⢏⣾⣿
⣿⣿⣿⣿⣿⠻⠿⠿⠿⠿⠿⠿⢛⣛⣭⣾⣿⣸⣿⣿
⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣿⣿⣿
"

# Prompt to proceed
echo -e -n "Do you like free things? [y/N]: "
read -r response

# Check if the user typed y or Y
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "\nInstallation aborted by user. No changes were made."
    exit 0
fi



set -e



# List of available packages
PACKAGES=(
    git
    python
    code
    neovim
    obsidian
)

# Array to store the packages the user actually wants
TO_INSTALL=()

echo -e "\n📦 Select packages to install:"

# Loop through each package and prompt the user
for pkg in "${PACKAGES[@]}"; do
    read -p "Install $pkg? [Y/n]: " choice
    case "$choice" in 
        [yY]|[yY][eE][sS]|"" )
            TO_INSTALL+=("$pkg")
            ;;
        * )
            echo "Skipping $pkg..."
            ;;
    esac
done

echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Check if the user selected any packages at all
if [ ${#TO_INSTALL[@]} -eq 0 ]; then
    echo "No packages selected. Exiting."
else
    echo "Installing chosen packages: ${TO_INSTALL[*]}"
    sudo pacman -S --noconfirm "${TO_INSTALL[@]}"
fi






check_status() {
    local name=$1
    local cmd=$2
    local version_cmd=$3

    # Check if the command exists silently
    if command -v "$cmd" >/dev/null 2>&1; then
        # Run the version command passed in the third argument
        local version=$(bash -c "$version_cmd")
        echo "✅ $name version: $version"
    else
        echo "❌ $name: Failed to install or command not found"
    fi
}





echo -e "\n--- Installation Summary ---"
# Loop dynamically through your main package list
for pkg in "${PACKAGES[@]}"; do
    # pacman -Q queries the local database. If successful, it's installed.
    if pacman -Q "$pkg" >/dev/null 2>&1; then
        # Grab just the version string (the second column of pacman -Q output)
        version=$(pacman -Q "$pkg" | awk '{print $2}')
        echo "✅ $pkg version: $version"
    else
        echo "❌ $pkg: Not installed"
    fi
done


echo -e "\n🎉 Bootstrap complete!\n"





