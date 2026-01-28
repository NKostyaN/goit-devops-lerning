#!/bin/bash

YELLOW='\033[0;93m'
CYAN='\033[0;96m'
NC='\033[0m'

echo -e "${CYAN}--- Починаємо встановлення ---${NC}"

# 1. Оновлення списку пакетів
sudo apt update

# 2. Встановлення Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Встановлюємо Docker...${NC}"

    sudo apt install -y ca-certificates curl
    sudo install -y -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce
else
    echo -e "${CYAN}Docker вже встановлений: $(docker --version)${NC}"
fi

# 3. Встановлення Docker Compose
if ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}Встановлюємо Docker Compose плагін...${NC}"
    sudo apt install -y docker-compose-plugin
else
    echo -e "${CYAN}Docker Compose вже встановлений: $(docker compose version)${NC}"
fi

# 4. Встановлення Python
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null)
REQUIRED_VERSION="3.9"

if [[ $(echo -e "$PYTHON_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]; then
    echo -e "${YELLOW}Встановлюємо Python 3.9 або новіше...${NC}"
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update
    sudo apt-get install -y python3.9 python3.9-venv python3-pip
else
    echo -e "${CYAN}Python $PYTHON_VERSION вже відповідає вимогам.${NC}"
fi

# 5. Встановлення Django
if ! python3 -m django --version &> /dev/null; then
    echo -e "${YELLOW}Встановлюємо Django...${NC}"
    pip3 install --upgrade pip --break-system-packages
    pip3 install django --break-system-packages
else
    echo -e "${CYAN}Django вже встановлено: $(python3 -m django --version)${NC}"
fi

sudo apt update
sudo apt autoremove -y --purge
echo -e "${CYAN}--- Встановлення завершено ---${NC}"