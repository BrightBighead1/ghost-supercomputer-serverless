#!/bin/bash
# freeshell.de setup script
# Run this after SSH into your freeshell VPS

set -e

echo "=== Ghost SuperComputer v3.0 — freeshell.de Setup ==="

# 1. Verify environment
echo "[1/8] Verifying environment..."
free -h
df -h ~
ulimit -a | grep -E "memory|open files|process"

# 2. Enable Podman
echo "[2/8] Configuring Podman..."
podman --version
loginctl enable-linger $(whoami) 2>/dev/null || true

# 3. Install podman-compose
echo "[3/8] Installing podman-compose..."
pip3 install --user podman-compose 2>/dev/null || pip install --user podman-compose
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 4. Create directories
echo "[4/8] Creating project directories..."
mkdir -p ~/ghost-supercomputer/{vps,hf-spaces,cloudflare,northflank,scripts,logs}
cd ~/ghost-supercomputer

# 5. Install cloudflared
echo "[5/8] Installing cloudflared..."
curl -L -o ~/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x ~/cloudflared
~/cloudflared --version

# 6. Create swap (may fail without root)
echo "[6/8] Attempting swap setup..."
dd if=/dev/zero of=~/swapfile bs=1M count=2048 2>/dev/null && \
chmod 600 ~/swapfile && \
mkswap ~/swapfile 2>/dev/null && \
swapon ~/swapfile 2>/dev/null && \
echo "Swap created" || echo "Swap creation requires root — continuing without swap"

# 7. Create monitoring script
echo "[7/8] Creating monitoring script..."
cat > ~/bin/monitor.sh << 'MONITOR'
#!/bin/bash
echo "=== Ghost SuperComputer Monitor ==="
echo ""
echo "--- Memory ---"
free -h
echo ""
echo "--- Disk ---"
df -h ~
echo ""
echo "--- Processes ($(ps aux | wc -l) / 150 max) ---"
echo ""
echo "--- Containers ---"
podman stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "No containers running"
echo ""
echo "=== $(date) ==="
MONITOR
chmod +x ~/bin/monitor.sh

# 8. Create watchdog
echo "[8/8] Creating watchdog script..."
cat > ~/bin/watchdog.sh << 'WATCHDOG'
#!/bin/bash
podman ps --format "{{.Names}}" 2>/dev/null | while read name; do
  status=$(podman inspect --format '{{.State.Status}}' "$name" 2>/dev/null)
  if [ "$status" != "running" ]; then
    podman start "$name" 2>/dev/null
    echo "$(date): Restarted $name" >> ~/logs/watchdog.log
  fi
done
WATCHDOG
chmod +x ~/bin/watchdog.sh

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "1. Clone the repo: git clone https://github.com/BrightBighead1/ghost-supercomputer-serverless.git ~/ghost-supercomputer"
echo "2. Copy .env.example to .env and fill in your values"
echo "3. Run: cd ~/ghost-supercomputer/vps && podman-compose up -d"
echo "4. Setup Cloudflare Tunnel with your domain"
