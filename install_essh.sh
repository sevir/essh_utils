#!/bin/bash


# Function to check and install required packages
install_dependencies() {
  if ! command -v unzip &> /dev/null || ! command -v wget &> /dev/null; then
    echo "unzip or wget not found, installing..."
    sudo apt install wget unzip -y
  fi
}

# Function to download and install essh
download_essh() {
  mkdir -p ~/.bin
  echo "Downloading essh..."
  wget https://github.com/sevir/essh/releases/download/v3.5.0/essh_linux_amd64.zip
  unzip essh_linux_amd64.zip -d ~/.bin
  mv ~/.bin/essh_linux_amd64 ~/.bin/essh
  chmod +x ~/.bin/essh
  rm essh_linux_amd64.zip
  echo "Finished installing essh"
  echo "Please add ~/.bin to your PATH"
}

install_essh() {
  install_dependencies
  mkdir -p ~/.bin
  download_essh
}

# if command essh not found, install it
if ! command -v essh &> /dev/null; then
  install_essh
fi

# Check if essh version is 3.5.0 or greater
if command -v essh &> /dev/null; then
  ESSH_VERSION=$(essh --version)
  # Remove the rest of string and keep only the version number
  ESSH_VERSION=$(echo $ESSH_VERSION | cut -d' ' -f1)

  # Extract major, minor, patch numbers
  MAJOR=$(echo $ESSH_VERSION | cut -d. -f1)
  MINOR=$(echo $ESSH_VERSION | cut -d. -f2)
  PATCH=$(echo $ESSH_VERSION | cut -d. -f3)

  # Compare with 3.5.0
  if [ "$MAJOR" -gt 3 ] || ([ "$MAJOR" -eq 3 ] && [ "$MINOR" -gt 5 ]) || ([ "$MAJOR" -eq 3 ] && [ "$MINOR" -eq 5 ] && [ "$PATCH" -ge 0 ]); then
    echo "essh version $ESSH_VERSION is greater or equal than 3.5.0"
  else
    echo "essh version $ESSH_VERSION is not greater than 3.5.0"
    install_essh
  fi
fi

echo "Downloading essh_utils..."
mkdir -p ~/.essh/lib
install_dependencies
wget https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/drivers.lua -O ~/.essh/lib/drivers.lua
wget https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/functions.lua -O ~/.essh/lib/functions.lua

echo "Finished installed essh_utils"
