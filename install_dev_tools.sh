#!/bin/bash

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

echo "Starting installation of DevOps tools..."

if is_installed docker; then
  echo "Docker is already installed"
else
  echo "⬇️ Installing Docker..."
  sudo apt update
  sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  echo "Docker has been installed"
fi

if is_installed docker-compose; then
  echo "Docker Compose is already installed"
else
  echo "⬇️ Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "Docker Compose has been installed"
fi

if is_installed python3 && python3 --version | grep -q "3.9\|[4-9]"; then
  echo "Python 3.9+ is already installed"
else
  echo "Installing Python 3.9..."
  sudo apt update
  sudo apt install -y python3 python3-pip
  echo "Python has been installed"
fi

if python3 -m django --version >/dev/null 2>&1; then
  echo "Django is already installed"
else
  echo "Installing Django..."
  python3 -m pip install --user django
  echo "Django has been installed"
fi

echo "All DevOps tools have been successfully installed!"
