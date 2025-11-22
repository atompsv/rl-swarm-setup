#!/bin/bash
set -e

echo "=== STOPPING RL-SWARM SERVICE ==="

# Kill the screen session
if screen -list | grep -q "swarm-session"; then
    echo ">>> Killing swarm screen session..."
    screen -S swarm-session -X quit
else
    echo ">>> No swarm screen session found."
fi

# Stop any running swarm container (just in case)
if command -v docker >/dev/null 2>&1; then
    CONTAINER=$(docker ps -q --filter "name=swarm")
    if [ -n "$CONTAINER" ]; then
        echo ">>> Stopping running swarm container(s)..."
        docker rm -f $CONTAINER
    else
        echo ">>> No running swarm container found."
    fi
else
    echo ">>> Docker not installed. Skipping container cleanup."
fi

echo "=== ALL RL-SWARM SERVICES STOPPED ==="
