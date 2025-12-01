sudo apt-get update

curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ focal main" | \

curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared

chmod +x cloudflared

sudo mv cloudflared /usr/local/bin/

cloudflared --version

sudo apt-get update


cloudflared tunnel --url http://localhost:3000