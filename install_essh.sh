sudo apt install wget unzip -y
mkdir -p ~/.bin
mkdir -p ~/.essh/lib
wget https://github.com/sevir/essh/releases/download/v3.5.0/essh_linux_amd64.zip
unzip essh_linux_amd64.zip -d ~/.bin
rm essh_linux_amd64.zip
wget https://raw.githubusercontent.com/sevir/essh/main/drivers.lua -O ~/.essh/lib/drivers.lua