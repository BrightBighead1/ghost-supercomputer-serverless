# Ghost SuperComputer — Complete Deployment Guide

## Overview

Deploy all 15 services for $0/month. No credit card required. Beats Oracle Cloud Free Tier.

| # | Service | Purpose | Free Tier | Time |
|---|---------|---------|-----------|------|
| 1 | GitHub Account | Code hosting + LLM API | Unlimited | 2 min |
| 2 | Hugging Face Account | Compute (16GB RAM) | 2 vCPU, 16GB | 2 min |
| 3 | Neon Database | PostgreSQL | 0.5 GB | 2 min |
| 4 | TiDB Cloud Serverless | MySQL/HTAP | 5 GB | 3 min |
| 5 | Qdrant Cloud | Vector search | 1 GB | 2 min |
| 6 | Modal | Heavy GPU compute | $30/mo | 3 min |
| 7 | Cloudflare R2 | File storage | 10 GB | 2 min |
| 8 | n8n Cloud | Workflow automation | 5 workflows | 5 min |
| 9 | Composio | Tool integrations | 1K exec/mo | 2 min |
| 10 | Firecrawl | Web scraping | 1K pages/mo | 2 min |
| 11 | UptimeRobot | Keep-alive #1 | 50 monitors | 2 min |
| 12 | cron-job.org | Keep-alive #2 | 50 jobs | 2 min |
| 13 | HF Space Deploy | Final deployment | 16GB RAM | 10 min |
| 14 | Post-deploy setup | Verify + configure | - | 5 min |
| 15 | Integration testing | End-to-end test | - | 5 min |

**Total setup time: ~45 minutes**

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

## Step 4: TiDB Cloud Serverless (3 minutes)

1. Go https://tidbcloud.com
2. Sign up with GitHub (free)
3. Click "Create Cluster"
4. Select "Serverless" tab
5. Cluster name: `ghost-supercomputer`
6. Region: closest to you
7. Click "Create"
8. Wait 30 seconds for provisioning
9. Go to "Connect" tab
10. Select "General" connection
11. Copy the connection details:

```
Host: xxxxx.tidbcloud.com
Port: 4000
User: xxxxx.root
Password: xxxxx
Database: test
```

**Save these as TIDB_HOST, TIDB_PORT, TIDB_USER, TIDB_PASSWORD, TIDB_DATABASE**

---

## Step 5: Qdrant Cloud (2 minutes)

1. Go to https://cloud.qdrant.io
2. Sign up with GitHub (free)
3. Click "Create Cluster"
4. Cluster name: `ghost-supercomputer`
5. Region: closest to you
6. Free tier: 1 GB
7. Click "Create"
8. Wait 30 seconds for provisioning
9. Go to "Cluster Details"
10. Copy the **Cluster URL** and **API Key**:

```
Cluster URL: https://xxxxx.qdrant.io:6333
API Key: xxxxx
```

**Save these as QDRANT_CLOUD_URL and QDRANT_CLOUD_API_KEY**

---

## Step 6: Modal (3 minutes)

1. Go to https://modal.com
2. Sign up with GitHub (free)
3. Complete onboarding
4. Go to "Settings" > "API Tokens"
5. Click "Create Token"
6. Name: `ghost-supercomputer`
7. Copy the **Token ID** and **Token Secret**:

```
Token ID: ak-xxxxx
Token Secret: xxxxx
```

**Save these as MODAL_TOKEN_ID and MODAL_TOKEN_SECRET**

6. Install Modal CLI on your local machine:

```bash
pip install modal
modal setup
```

---

## Step 7: Cloudflare R2 Storage (2 minutes)

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

## Step 8: n8n Cloud (5 minutes)

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

## Step 9: Composio (2 minutes)

1. Go to https://composio.dev
2. Sign up with GitHub (free)
3. Go to Dashboard
4. Copy your API key

**Your API key:** `xxxxxxxxxxxxxxxxxxxxxxxx`

---

## Step 10: Firecrawl (2 minutes)

1. Go to https://firecrawl.dev
2. Sign up with GitHub (free)
3. Go to "API Keys"
4. Copy your API key

**Your API key:** `fc-xxxxxxxxxxxxxxxxxxxxxxxx`

---

## Step 11: UptimeRobot (2 minutes)

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

## Step 12: cron-job.org (2 minutes)

1. Go to https://cron-job.org
2. Sign up (free)
3. Click "Create Job"
4. URL: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/health`
5. Schedule: Every 10 minutes
6. Request Method: GET
7. Save

**Status:** Will ping your Space every 10 minutes

---

## Step 13: HF Space Deployment (10 minutes)

1. Go to https://huggingface.co/new-space
2. Space name: `ghost-supercomputer`
3. License: MIT
4. SDK: `Docker`
5. Visibility: Public
6. Click "Create Space"

### 13.1: Add Environment Variables

Go to your Space: `https://huggingface.co/spaces/YOUR_USERNAME/ghost-supercomputer`

Click "Settings" tab > "Repository secrets"

Add these variables:

| Variable | Value |
|----------|-------|
| `NEON_DATABASE_URL` | `postgresql://...neon.tech/neondb?sslmode=require` |
| `TIDB_HOST` | `xxxxx.tidbcloud.com` |
| `TIDB_PORT` | `4000` |
| `TIDB_USER` | `xxxxx.root` |
| `TIDB_PASSWORD` | `xxxxx` |
| `TIDB_DATABASE` | `test` |
| `QDRANT_CLOUD_URL` | `https://xxxxx.qdrant.io:6333` |
| `QDRANT_CLOUD_API_KEY` | `xxxxx` |
| `MODAL_TOKEN_ID` | `ak-xxxxx` |
| `MODAL_TOKEN_SECRET` | `xxxxx` |
| `CF_R2_ENDPOINT` | `https://xxxx.r2.cloudflarestorage.com` |
| `CF_R2_ACCESS_KEY_ID` | (from Cloudflare R2) |
| `CF_R2_SECRET_ACCESS_KEY` | (from Cloudflare R2) |
| `CF_R2_BUCKET` | `ghost-storage` |
| `GITHUB_TOKEN` | `ghp_xxxx` (from GitHub Models) |
| `OPENAI_API_KEY` | `ghp_xxxx` (same as GITHUB_TOKEN) |
| `N8N_WEBHOOK_URL` | `https://your-name.app.n8n.cloud/webhook/ghost-notify` |
| `COMPOSIO_API_KEY` | `xxxx` (from Composio) |
| `FIRECRAWL_API_KEY` | `fc-xxxx` (from Firecrawl) |
| `GHOST_ENV` | `production` |
| `TZ` | `UTC` |
| `KEEP_ALIVE_INTERVAL` | `300` |
| `N8N_ENCRYPTION_KEY` | (generate a random 32-char string) |
| `GENERIC_TIMEZONE` | `UTC` |

### 13.2: Upload Files

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

### 13.3: Build and Deploy

1. After uploading, go to "App" tab
2. You'll see "Building" status
3. Wait 5-10 minutes for Docker build
4. Watch logs for errors
5. When status shows "Running" — you're live!

---

## Step 14: Post-Deploy Setup (5 minutes)

### 14.1: Initialize PocketBase

1. Go to Terminal: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/terminal/`
2. Login: `ghost` / `ghost`
3. Run:

```bash
# Create admin user
pocketbase migrate --dir=/data/pocketbase
```

4. Go to PocketBase: `https://YOUR_USERNAME-ghost-supercomputer.hf.space/pb/`
5. Click "Create first admin account"
6. Set email and password

### 14.2: Initialize Qdrant Collections

1. Go to Terminal
2. Run:

```bash
curl -X PUT "http://127.0.0.1:6333/collections/ghost_memory" \
  -H "Content-Type: application/json" \
  -d '{
    "vectors": {
      "size": 1536,
      "distance": "Cosine"
    }
  }'
```

### 14.3: Test TiDB Connection

1. Go to Terminal
2. Run:

```bash
mysql -h $TIDB_HOST -P $TIDB_PORT -u $TIDB_USER -p$TIDB_PASSWORD $TIDB_DATABASE -e "SELECT 1;"
```

### 14.4: Test Neon Connection

1. Go to Terminal
2. Run:

```bash
psql "$NEON_DATABASE_URL" -c "SELECT 1;"
```

---

## Step 15: Integration Testing (5 minutes)

### Test All Services

| Service | Test Command | Expected |
|---------|-------------|----------|
| Health | `curl /health` | `OK` |
| GitAgent | `curl /agent/` | HTML response |
| n8n | `curl /n8n/` | HTML response |
| PocketBase | `curl /pb/api/health` | JSON |
| Qdrant | `curl /qdrant/healthz` | `OK` |
| Terminal | Open `/terminal/` | Web terminal |

### Test External Services

| Service | Test | Expected |
|---------|------|----------|
| Neon | `psql $NEON_DATABASE_URL -c "SELECT 1;"` | `1` |
| TiDB | `mysql -h $TIDB_HOST -e "SELECT 1;"` | `1` |
| Qdrant Cloud | `curl -H "api-key: $QDRANT_CLOUD_API_KEY" $QDRANT_CLOUD_URL/collections` | JSON |
| Modal | `modal profile list` | Your profile |
| Cloudflare R2 | `aws s3 ls --endpoint-url $CF_R2_ENDPOINT` | Bucket list |
| Composio | `curl -H "x-api-key: $COMPOSIO_API_KEY" https://api.composio.dev/apps` | JSON |
| Firecrawl | `curl -H "Authorization: Bearer $FIRECRAWL_API_KEY" https://api.firecrawl.dev/v1/scrape` | JSON |

---

## Verify Everything Works

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

### TiDB Connection Fails

1. Check TIDB_HOST, TIDB_PORT, TIDB_USER, TIDB_PASSWORD
2. Ensure cluster is "Active" in TiDB Cloud dashboard
3. Check IP whitelist (should allow all for serverless)

### Qdrant Cloud Connection Fails

1. Check QDRANT_CLOUD_URL and QDRANT_CLOUD_API_KEY
2. Ensure cluster is "Active" in Qdrant Cloud dashboard
3. Check if cluster is paused (free tier pauses after inactivity)

### Modal Functions Fail

1. Check MODAL_TOKEN_ID and MODAL_TOKEN_SECRET
2. Run `modal profile list` to verify authentication
3. Check Modal dashboard for function logs

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
- [ ] All 24 env vars set in Space Settings
- [ ] Docker build succeeds (green status)
- [ ] `/health` returns "OK"
- [ ] GitAgent accessible at `/agent/`
- [ ] n8n accessible at `/n8n/`
- [ ] PocketBase accessible at `/pb/`
- [ ] Qdrant accessible at `/qdrant/`
- [ ] Terminal accessible at `/terminal/`
- [ ] Neon database connected
- [ ] TiDB connected
- [ ] Qdrant Cloud connected
- [ ] Modal authenticated
- [ ] Cloudflare R2 accessible
- [ ] Composio connected
- [ ] Firecrawl connected
- [ ] UptimeRobot shows "Up"
- [ ] cron-job.org shows "Success"

---

## Cost Summary

| Service | Free Tier | Paid |
|---------|-----------|------|
| Hugging Face Spaces | 2 vCPU, 16GB RAM | $0 |
| Neon Database | 0.5GB storage | $0 |
| TiDB Cloud Serverless | 5GB storage | $0 |
| Qdrant Cloud | 1GB vectors | $0 |
| Modal | $30/mo compute | $0 |
| Cloudflare R2 | 10GB storage | $0 |
| n8n Cloud | 5 workflows | $0 |
| Composio | 1K executions | $0 |
| Firecrawl | 1K pages/mo | $0 |
| GitHub Models | gpt-4o-mini | $0 |
| UptimeRobot | 50 monitors | $0 |
| cron-job.org | 50 jobs | $0 |
| PocketBase | Local SQLite | $0 |
| Qdrant Local | Local storage | $0 |
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
