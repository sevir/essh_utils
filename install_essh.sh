# if command essh not found, install it
if ! command -v essh &> /dev/null; then
  # if command unzip and wget not found, install it
    if ! command -v unzip &> /dev/null || ! command -v wget &> /dev/null; then
        sudo apt install wget unzip -y
    fi
    mkdir -p ~/.bin

  wget https://github.com/sevir/essh/releases/download/v3.5.0/essh_linux_amd64.zip
  unzip essh_linux_amd64.zip -d ~/.bin
  rm essh_linux_amd64.zip
fi

mkdir -p ~/.essh/lib
wget https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/drivers.lua -O ~/.essh/lib/drivers.lua