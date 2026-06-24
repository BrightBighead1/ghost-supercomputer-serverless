# Ghost SuperComputer v3.0 — Deployment Guide

**$0/month | 35 Tools | 6 Platforms**

---

## Prerequisites

- freeshell.de VPS (postcard activation required)
- Hugging Face account
- Cloudflare account (buy domain ~$8.57/yr)
- Northflank account (credit card required for verification)
- PandaStack account
- Modal account

---

## Step 1: freeshell.de VPS Setup

```bash
# 1. Wait for postcard activation email
# 2. SSH in
ssh yourlogin@freeshell.de

# 3. Run setup script
bash <(curl -fsSL https://raw.githubusercontent.com/BrightBighead1/ghost-supercomputer-serverless/main/scripts/setup-freeshell.sh)

# 4. Clone the repo
git clone https://github.com/BrightBighead1/ghost-supercomputer-serverless.git ~/ghost-supercomputer
cd ~/ghost-supercomputer

# 5. Configure environment
cp .env.example .env
nano .env  # Fill in your values
```

---

## Step 2: Cloudflare Setup

### 2a. Buy Domain
1. Go to https://dash.cloudflare.com → Domain Registration
2. Search and buy your domain (~$8.57/yr for .com)

### 2b. Create Tunnel
1. Go to Zero Trust → Networks → Tunnels → Create
2. Select "Cloudflared" → Name it → Copy the token
3. Add token to your `.env` file

### 2c. Route Subdomains
In Cloudflare Dashboard → DNS → Records, add:
```
CNAME  cowagent    → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  omniroute   → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  n8n         → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  qdrant      → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  pocketbase  → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  monitor     → <tunnel-id>.cfargotunnel.com  (Proxied)
CNAME  terminal    → <tunnel-id>.cfargotunnel.com  (Proxied)
```

### 2d. Setup Access (GitHub OAuth)
1. GitHub → Settings → Developer Settings → OAuth Apps → New
2. Callback URL: `https://your-team.cloudflareaccess.com/cdn-cgi/access/callback`
3. Copy Client ID + Secret to Cloudflare Zero Trust → Authentication → GitHub

---

## Step 3: Start VPS Services

```bash
cd ~/ghost-supercomputer/vps

# Start all services
podman-compose up -d

# Check status
podman-compose ps
podman-compose logs --tail=50

# Verify each service
curl http://localhost:9899   # CowAgent
curl http://localhost:3000   # OmniRoute
curl http://localhost:6333   # Qdrant
curl http://localhost:5678   # n8n
curl http://localhost:8090   # PocketBase
curl http://localhost:3001   # Uptime Kuma
curl http://localhost:7681   # ttyd
```

---

## Step 4: Configure OmniRoute

1. Open `http://localhost:3000` (or via Cloudflare Tunnel)
2. Go to Providers → Add Provider → **Kiro**
3. Complete OAuth login (AWS/Google/GitHub)
4. Go to Providers → Add Provider → **Qoder**
5. Complete OAuth login
6. Go to Providers → Add Provider → **Pollinations** (no key needed)
7. Go to Combos → Create combo with fallback chain:
   - Priority 1: `kr/claude-sonnet-4.5`
   - Priority 2: `if/deepseek-r1`
   - Priority 3: `pol/gpt-5`
8. Copy your API key from Dashboard → Endpoints
9. Update `vps/cowagent/config.json` with your API key

---

## Step 5: Configure CowAgent

1. Open `http://localhost:9899` (or via Cloudflare Tunnel)
2. Go to Channels → Add Channel → Telegram
3. Message @BotFather → `/newbot` → paste token
4. Go to Channels → Add Channel → Discord
5. Create app at https://discord.com/developers → Bot → paste token
6. Test by sending a message to your bot

---

## Step 6: HF Spaces Setup

```bash
# 1. Create a new Docker Space on huggingface.co
# 2. Clone it locally
git clone https://huggingface.co/spaces/YOUR_USERNAME/YOUR_SPACE

# 3. Copy files
cp -r ~/ghost-supercomputer/hf-spaces/* YOUR_SPACE/

# 4. Push
cd YOUR_SPACE
git add .
git commit -m "Initial deploy"
git push
```

### Set HF Secrets
In Space Settings → Variables and secrets:
- `CODE_SERVER_PASSWORD` = your strong password
- `HF_TOKEN` = your HF write token
- `HF_USERNAME` = your HF username
- `HF_SPACE_NAME` = your space name

---

## Step 7: Northflank Setup

1. Sign up at https://northflank.com (credit card required)
2. Create project → Developer Sandbox
3. Link GitHub account
4. Create service → Deploy `northflank/mcp-server/` directory
5. Expose port 8080
6. Create PostgreSQL addon → link to service

---

## Step 8: PandaStack Setup

1. Sign up at https://dashboard.pandastack.io (no credit card)
2. Connect GitHub repo
3. Deploy `pandastack/` directory as static site

---

## Step 9: Modal Setup

```bash
pip install modal
python3 -m modal setup  # Authenticates via browser

# Deploy GPU functions
modal deploy modal/gpu_tasks.py
```

---

## Step 10: GitHub Actions

1. Go to your GitHub repo → Settings → Secrets
2. Add secrets:
   - `HF_USERNAME`
   - `HF_SPACE_NAME`
   - `HF_TOKEN`
3. The workflows will auto-run:
   - `keep-alive.yml` — pings HF Space every 6 hours
   - `code-sync.yml` — syncs code on push to main

---

## Verification Checklist

- [ ] CowAgent responding at `http://cowagent.yourdomain.com`
- [ ] OmniRoute dashboard at `http://omniroute.yourdomain.com`
- [ ] n8n workflows at `http://n8n.yourdomain.com`
- [ ] Qdrant API at `http://qdrant.yourdomain.com`
- [ ] PocketBase admin at `http://pocketbase.yourdomain.com/_/`
- [ ] Uptime Kuma at `http://monitor.yourdomain.com`
- [ ] Terminal at `http://terminal.yourdomain.com`
- [ ] HF Spaces code-server at `https://your-space.hf.space`
- [ ] Telegram bot responding
- [ ] Discord bot responding
- [ ] OmniRoute free providers working (Kiro, Qoder, Pollinations)
- [ ] Qdrant storing vectors
- [ ] n8n workflows running
- [ ] Cloudflare Access blocking unauthorized users
- [ ] Uptime Kuma monitoring all services

---

## Troubleshooting

### Container won't start
```bash
podman-compose logs service-name
podman inspect service-name
```

### Out of memory
```bash
free -h
podman stats --no-stream
# Reduce mem_limit in docker-compose.yml
```

### Port already in use
```bash
ss -tlnp | grep PORT
# Change port mapping in docker-compose.yml
```

### HF Space sleeping
- Check GitHub Actions keep-alive workflow
- Manually visit the Space URL to wake it
