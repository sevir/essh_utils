# if command essh not found, install it
if ! command -v essh &> /dev/null; then
  # if command unzip and wget not found, install it
    if ! command -v unzip &> /dev/null || ! command -v wget &> /dev/null; then
        echo "unzip or wget not found, installing..."
        sudo apt install wget unzip -y
    fi
    mkdir -p ~/.bin

  echo "Downloading essh..."
  wget https://github.com/sevir/essh/releases/download/v3.5.0/essh_linux_amd64.zip
  unzip essh_linux_amd64.zip -d ~/.bin
  rm essh_linux_amd64.zip

  echo "Finished installing essh"
  echo "Please add ~/.bin to your PATH"
fi

echo "Downloading essh_utils..."
mkdir -p ~/.essh/lib
wget https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/drivers.lua -O ~/.essh/lib/drivers.lua
wget https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/functions.lua -O ~/.essh/lib/functions.lua

echo "Finished installed essh_utils"
