# RL-Swarm Setup on Ubuntu 24

This guide will help you **install, start, and connect to RL-Swarm** on Ubuntu 24 using Docker, Docker Compose, and LocalTunnel.

---

## 1️⃣ Clone the repository

```bash
git clone https://github.com/yourusername/rl-swarm-setup.git
cd rl-swarm-setup
chmod +x setup_rl_swarm.sh stop_rl_swarm.sh
```

---

## 2️⃣ Start RL-Swarm

Run the setup script:

```bash
./setup_rl_swarm.sh
```

* The script will install all dependencies, clone `rl-swarm`, and start the service in a **screen session**.
* You will see a message:

```
Waiting for service to start...
```

* **Patience:** It may take **10–20 minutes**.
* When the service is ready, you will see:

```
Service is running on port 3000!
```

* A **LocalTunnel URL** will also appear.

---

## 3️⃣ Connect to RL-Swarm

1. Open the **LocalTunnel URL** in your browser.
2. Fill in your **public IP**.
3. Login using your **email and passcode**.
4. Once logged in successfully, return to your terminal and press CTRL+C to exit the setup script.
Note: Exiting here does not stop the service; it continues running in the background via screen.


---

## 4️⃣ Access the swarm screen

1. List running screen sessions:

```bash
screen -ls
```

2. Reattach to the swarm session:

```bash
screen -r swarm-session
```

3. You will see prompts like:

```
Would you like to push models you train in the RL swarm to the Hugging Face Hub? [y/N]
```

* Type `N` → Enter
* Press **Enter** for the next prompt (use default model)
* Wait for:

```
Connected to Gensyn Testnet
```

---

## 5️⃣ Verify on Gensyn Dashboard

1. Open: [https://dashboard.gensyn.ai/](https://dashboard.gensyn.ai/)
2. Login with the same email you used before
3. Scroll to **"RL Swarm : Your Nodes"**
4. If you see your nodes listed → you successfully joined the swarm.

---

## 6️⃣ Detach and keep running in background

* Detach from the screen session without stopping the service:

```bash
CTRL + A, then D
```

* The swarm service keeps running in the background.

---

## 7️⃣ Stop RL-Swarm

To stop the swarm and cleanup:

```bash
./stop_rl_swarm.sh
```

* This stops the screen session and any running containers.

---

## 8️⃣ Notes

* Make sure **port 3000** is free before starting.
* LocalTunnel requires an **internet connection**.
* Scripts are safe to run multiple times — they handle cleanup automatically.

---

🎉 **All done! You are now part of the RL-Swarm network.**