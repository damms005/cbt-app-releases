#!/bin/bash

# Create a folder named cbt-app in the home directory if it doesn't exist
INSTALL_DIR="$HOME/cbt-app"
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Update and install zlib1g-dev without prompts
echo "Updating package list and installing zlib1g-dev..."
sudo apt-get update -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y zlib1g-dev

# Prevent the prompt for restarting services
sudo apt-get install -y needrestart
sudo sed -i 's/#\$nrconf{restart} =.*/$nrconf{restart} = "a";/' /etc/needrestart/needrestart.conf

echo "Package installation completed."

# Check system architecture and adjust download URL accordingly
ARCH=$(uname -m)
if [ "$ARCH" == "aarch64" ]; then
    # aarch64 corresponds to arm64 AppImage
    echo "Detected architecture: aarch64 (Using arm64 AppImage)"
    arch_type="arm64"
else
    # For other architectures like x86_64, use the native architecture
    echo "Detected architecture: $ARCH"
    arch_type="$ARCH"
fi

# Fetch the list of all releases and find the latest release with the correct AppImage
echo "Fetching the latest CBT Deployer release..."
latest_release_url=$(curl -s https://api.github.com/repos/damms005/cbt-docker-app-deployer-releases/releases | grep "browser_download_url.*$arch_type.AppImage" | head -n 1 | cut -d '"' -f 4)

# Download the latest CBT Deployer to the cbt-app directory
if [ -n "$latest_release_url" ]; then
    echo "Downloading the CBT Deployer from: $latest_release_url"
    wget -q --show-progress "$latest_release_url" -O "$INSTALL_DIR/CBT-Deployer.AppImage"
else
    echo "Failed to fetch the correct version for your platform."
    exit 1
fi

# Make the file executable
chmod +x "$INSTALL_DIR/CBT-Deployer.AppImage"
echo "Downloaded and set CBT Deployer as executable."

# Launch the app
echo "Launching CBT Deployer..."
"$INSTALL_DIR/CBT-Deployer.AppImage" &

# Conspicuous completion message with installation path. We 
# initially made thie a shortcut app, but the app weirdly was not 
# working in the Ubuntu 24.04 qemu macos UTM app virtualization that 
# I used for the testing, neither does directly clicking the icon from
# nautilus (in this case it was a weird error in the app after providing
# the sudo password - simply didn't accept the password). But this works!!
echo -e "\n========== INSTALLATION COMPLETE =========="
echo -e "CBT Deployer has been installed in the following location:"
echo -e "\033[1m$INSTALL_DIR/CBT-Deployer.AppImage\033[0m"
echo -e "To launch the app later, open a terminal, drag the AppImage file into the terminal, and hit ENTER.\n"
echo -e "Example:"
echo -e "\033[1m$INSTALL_DIR/CBT-Deployer.AppImage\033[0m\n"
echo -e "==========================================="
