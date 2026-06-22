# Ghost SuperComputer — Complete Deployment Guide

## Overview

Deploy all 10 services for $0/month. No credit card required.

| # | Service | Purpose | Time | URL |
|---|---------|---------|------|-----|
| 1 | GitHub Account | Code hosting | 2 min | github.com |
| 2 | Hugging Face Account | Compute (16GB RAM) | 2 min | huggingface.co |
| 3 | Neon Database | PostgreSQL (0.5GB free) | 2 min | neon.com |
| 4 | Cloudflare Account | R2 Storage (10GB free) | 2 min | dash.cloudflare.com |
| 5 | n8n Cloud | Workflow automation | 5 min | n8n.cloud |
| 6 | UptimeRobot | Keep-alive #1 | 2 min | uptimerobot.com |
| 7 | cron-job.org | Keep-alive #2 | 2 min | cron-job.org |
| 8 | GitHub Models | LLM API (free tier) | 2 min | github.com/marketplace |
| 9 | Composio | Tool integrations | 2 min | composio.dev |
| 10 | HF Space Deploy | Final deployment | 5 min | huggingface.co/spaces |

**Total setup time: ~25 minutes**

---

## Step 1: GitHub Account (2 minutes)

1. Go to https://github.com
2. Sign up (free)
3. Verify email

**Your repo:** https://github.com/BrightBighead1/ghost-supercomputer-serverless

---

## Step 2: Hugging Face Account (2 minutes)

1. Go to https://huggingface.co
2. Sign up (free)
3. Go to https://huggingface.co/settings/tokens
4. Click "New token"
5. Name: `ghost-deploy`
6. Role: `Write`
7. Click "Generate token"
8. **Copy and save this token** — you need it later

**Your token looks like:** `hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxx`

---

## Step 3: Neon Database (2 minutes)

1. Go to https://neon.com
2. Sign up with GitHub (free)
3. Click "Create Project"
4. Project name: `ghost-supercomputer`
5. Region: closest to you
6. Click "Create Project"
7. Go to "Connection Details" tab
8. Copy the **Pooled connection string**:

```
postgresql://neondb_owner:xxxxxxxx@ep-xxxxx.us-east-2.aws.neon.tech/neondb?sslmode=require
```

**Save this as NEON_DATABASE_URL**

---

## Step 4: Cloudflare R2 Storage (2 minutes)

1. Go to https://dash.cloudflare.com
2. Sign up (free — no credit card)
3. Left sidebar: "R2 Object Storage"
4. Click "Create bucket"
5. Bucket name: `ghost-storage`
6. Location: closest to you
7. Click "Create bucket"
8. Go to "R2" > "Manage R2 API Tokens"
9. Click "Create API token"
10. Permissions: `Object Read & Write`
11. Click "Create API Token"
12. **Copy and save:**
    - Access Key ID
    - Secret Access Key
    - Endpoint URL (looks like: `https://xxxx.r2.cloudflarestorage.com`)

**Your bucket URL will be:** `https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com`

---

## Step 5: n8n Cloud (5 minutes)

1. Go to https://n8n.cloud
2. Sign up (free — 5 workflows included)
3. Complete onboarding
4. Go to Settings > API
5. Create an API key
6. Go to Settings > Variables
7. Add these variables:

| Variable | Value |
|----------|-------|
| `GHOST_ENV` | `production` |
| `NEON_DATABASE_URL` | (your Neon connection string) |
| `TZ` | `UTC` |

8. Go to "Workflows"
9. Create a new workflow named `Ghost Notifications`
10. Add a Webhook trigger:
    - HTTP Method: POST
    - Path: `ghost-notify`
11. Save the workflow
12. Copy the webhook URL:

```
https://your-name.app.n8n.cloud/webhook/ghost-notify
```

**Save this as N8N_WEBHOOK_URL**

---

## Step 6: GitHub Models API (2 minutes)

1. Go to https://github.com/marketplace/models
2. Find `gpt-4o-mini`
3. Click "Buy" (it's free — $0.00)
4. Go to https://github.com/settings/tokens
5. Click "Generate new token (classic)"
6. Name: `ghost-llm`
7. Select scopes: `models:read`
8. Click "Generate token"
9. **Copy and save this token**

**Your API key:** `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx`

---

## Step 7: UptimeRobot (2 minutes)

1. Go to https://uptimerobot.com
2. Sign up (free)
3. Click "Add New Monitor"
4. Monitor Type: HTTP(s)
5. Friendly Name: `Ghost SuperComputer`
6. URL: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/health`
7. Monitoring Interval: 5 minutes
8. Click "Create Monitor"

**Status:** Should show "Up" once HF Space is deployed

---

## Step 8: cron-job.org (2 minutes)

1. Go to https://cron-job.org
2. Sign up (free)
3. Click "Create Job"
4. URL: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/health`
5. Schedule: Every 10 minutes
6. Request Method: GET
7. Save

**Status:** Will ping your Space every 10 minutes

---

## Step 9: Composio (2 minutes)

1. Go to https://composio.dev
2. Sign up with GitHub (free)
3. Go to Dashboard
4. Copy your API key

**Your API key:** `xxxxxxxxxxxxxxxxxxxxxxxx`

---

## Step 10: HF Space Deployment (5 minutes)

1. Go to https://huggingface.co/new-space
2. Space name: `ghost-supercomputer`
3. License: MIT
4. SDK: `Docker`
5. Visibility: Public
6. Click "Create Space"

### 10.1: Add Environment Variables

Go to your Space: `https://huggingface.co/spaces/YOUR_USERNAME/ghost-supercomputer`

Click "Settings" tab > "Repository secrets"

Add these variables:

| Variable | Value |
|----------|-------|
| `NEON_DATABASE_URL` | `postgresql://...neon.tech/neondb?sslmode=require` |
| `CF_R2_ENDPOINT` | `https://xxxx.r2.cloudflarestorage.com` |
| `CF_R2_ACCESS_KEY_ID` | (from Cloudflare R2) |
| `CF_R2_SECRET_ACCESS_KEY` | (from Cloudflare R2) |
| `CF_R2_BUCKET` | `ghost-storage` |
| `GITHUB_TOKEN` | `ghp_xxxx` (from GitHub Models) |
| `OPENAI_API_KEY` | `ghp_xxxx` (same as GITHUB_TOKEN) |
| `N8N_WEBHOOK_URL` | `https://your-name.app.n8n.cloud/webhook/ghost-notify` |
| `COMPOSIO_API_KEY` | `xxxx` (from Composio) |
| `GHOST_ENV` | `production` |
| `TZ` | `UTC` |
| `KEEP_ALIVE_INTERVAL` | `300` |
| `N8N_ENCRYPTION_KEY` | (generate a random 32-char string) |
| `GENERIC_TIMEZONE` | `UTC` |

### 10.2: Upload Files

**Option A: Web Interface (easiest)**

Go to your Space > "Files" tab

Upload each file one by one:

```
Dockerfile
README.md
DEPLOY.md
.env.example
supervisord.conf
nginx.conf
start.sh
keep-alive.sh
agent/agent.yaml
agent/SOUL.md
agent/RULES.md
agent/tools/query_database.yaml
agent/tools/search_docs.yaml
agent/tools/send_notification.yaml
agent/tools/upload_file.yaml
scripts/query_db.sh
scripts/search.sh
scripts/upload_r2.sh
scripts/notify.sh
```

**Option B: Git Push (recommended)**

On your local machine, clone the repo and push to HF Space:

```bash
# Add HF as remote
git remote add hf https://huggingface.co/spaces/YOUR_USERNAME/ghost-supercomputer

# Push
git push hf main
```

**Option C: HF CLI**

```bash
pip install huggingface_hub
huggingface-cli login
huggingface-cli upload YOUR_USERNAME/ghost-supercomputer . --include="Dockerfile,README.md,DEPLOY.md,.env.example,supervisord.conf,nginx.conf,start.sh,keep-alive.sh,agent/**/*,scripts/**/*"
```

### 10.3: Build and Deploy

1. After uploading, go to "App" tab
2. You'll see "Building" status
3. Wait 5-10 minutes for Docker build
4. Watch logs for errors
5. When status shows "Running" — you're live!

---

## Step 11: Verify Everything Works

### Check Service URLs

Replace `YOUR_USERNAME` with your HF username:

| Service | URL |
|---------|-----|
| Dashboard | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/` |
| GitAgent | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/agent/` |
| n8n | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/n8n/` |
| PocketBase | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/pb/` |
| Qdrant | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/qdrant/` |
| Terminal | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/terminal/` |
| Health | `https://YOUR_USERNAME-ghost-supercomputer.hf.space/health` |

### Check Health Endpoint

```bash
curl https://YOUR_USERNAME-ghost-supercomputer.hf.space/health
# Should return: OK
```

### Check UptimeRobot

1. Go to UptimeRobot dashboard
2. Should show "Up" with green status
3. First check happens within 5 minutes

### Check cron-job.org

1. Go to cron-job.org dashboard
2. Should show "Success" status
3. First check happens within 10 minutes

---

## Troubleshooting

### Build Fails

1. Go to your Space > "App" tab > "Logs"
2. Look for the error
3. Common fixes:
   - Check all env vars are set correctly
   - Make sure Dockerfile has no syntax errors
   - Ensure all uploaded files are present

### Services Don't Start

1. Go to Terminal: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/terminal/`
2. Login: `ghost` / `ghost`
3. Check supervisor status:
   ```bash
   supervisorctl status
   ```
4. Check individual logs:
   ```bash
   supervisorctl tail -f gitagent
   supervisorctl tail -f n8n
   ```

### Keep-Alive Not Working

1. Verify health endpoint returns 200:
   ```bash
   curl -I https://YOUR_USERNAME-ghost-supercomputer.hf.space/health
   ```
2. Check UptimeRobot monitor is "Up"
3. Check cron-job.org runs are "Success"

### Space Sleeps After 48 Hours

This means keep-alive isn't working. Fix:

1. Verify UptimeRobot is monitoring every 5 minutes
2. Verify cron-job.org runs every 10 minutes
3. Both should ping `/health` endpoint
4. Check Space logs for errors

---

## Post-Deployment Checklist

- [ ] All 19 files uploaded to HF Space
- [ ] All 14 env vars set in Space Settings
- [ ] Docker build succeeds (green status)
- [ ] `/health` returns "OK"
- [ ] UptimeRobot shows "Up"
- [ ] cron-job.org shows "Success"
- [ ] GitAgent accessible at `/agent/`
- [ ] n8n accessible at `/n8n/`
- [ ] PocketBase accessible at `/pb/`
- [ ] Qdrant accessible at `/qdrant/`
- [ ] Terminal accessible at `/terminal/`
- [ ] Neon database connected
- [ ] Cloudflare R2 accessible
- [ ] LLM API responding

---

## Cost Summary

| Service | Free Tier | Paid |
|---------|-----------|------|
| Hugging Face Spaces | 2 vCPU, 16GB RAM | $0 |
| Neon Database | 0.5GB storage | $0 |
| Cloudflare R2 | 10GB storage | $0 |
| n8n Cloud | 5 workflows | $0 |
| GitHub Models | gpt-4o-mini | $0 |
| UptimeRobot | 50 monitors | $0 |
| cron-job.org | 50 jobs | $0 |
| Composio | 1K executions | $0 |
| PocketBase | Local SQLite | $0 |
| Qdrant | Local storage | $0 |
| ttyd | Local terminal | $0 |
| **Total** | **$0/month** | **$0** |

---

## Your URLs (copy these)

```
Dashboard:   https://YOUR_USERNAME-ghost-supercomputer.hf.space/
Agent:       https://YOUR_USERNAME-ghost-supercomputer.hf.space/agent/
Workflows:   https://YOUR_USERNAME-ghost-supercomputer.hf.space/n8n/
Database:    https://YOUR_USERNAME-ghost-supercomputer.hf.space/pb/
Vectors:     https://YOUR_USERNAME-ghost-supercomputer.hf.space/qdrant/
Terminal:    https://YOUR_USERNAME-ghost-supercomputer.hf.space/terminal/
Health:      https://YOUR_USERNAME-ghost-supercomputer.hf.space/health
```
