#!/bin/bash
set -e

echo "=== CLEANUP OLD INSTALLATIONS ==="

# Remove old rl-swarm containers if Docker exists
if command -v docker >/dev/null 2>&1; then
    echo ">>> Removing old rl-swarm containers..."
    docker ps -aq --filter "name=swarm" | xargs -r docker rm -f
else
    echo ">>> Docker not found. Skipping container cleanup."
fi

# Remove rl-swarm folder if exists
if [ -d "rl-swarm" ]; then
    echo ">>> Removing old rl-swarm folder..."
    rm -rf rl-swarm
fi

# Remove old Docker and Compose safely
sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker.io || true

# Remove Node/npm
sudo apt remove -y nodejs npm || true
sudo npm uninstall -g localtunnel || true

# Remove old Docker repo key if exists
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/apt/keyrings/docker.asc

echo "=== SYSTEM UPDATE & BASE DEPENDENCIES ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip curl wget git build-essential ca-certificates screen gnupg lsb-release

echo "=== INSTALL NODE.JS & LOCALTUNNEL ==="
sudo apt install -y nodejs npm
sudo npm install -g localtunnel

echo "=== INSTALL DOCKER + DOCKER COMPOSE PLUGIN ==="
# Using the same Docker install steps as your previous working script
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

echo "=== TEST DOCKER ==="
sudo docker run --rm hello-world
docker compose version

echo "=== CLONE RL-SWARM ==="
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm || exit

echo "=== START SWARM SERVICE IN SCREEN ==="
screen -S swarm-session -dm bash -c "docker compose run --rm --build -Pit swarm-cpu"

echo "=== WAITING FOR SERVICE TO BE READY ON PORT 3000 ==="
while ! ss -tulnp 2>/dev/null | grep -q ":3000"; do
    echo "Waiting for service to start..."
    sleep 2
done

echo ">>> Service is running on port 3000!"

echo "=== STARTING LOCALTUNNEL ==="
lt --port 3000

echo "=== ALL DONE ==="