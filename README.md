---
title: Ghost SuperComputer
emoji: "\U0001F47B"
colorFrom: purple
colorTo: blue
sdk: docker
app_port: 7860
pinned: true
---

# Ghost SuperComputer

$0/month AI agent hosting platform. No credit card required. No student email. No trial expiration.

## What You Get

- **16 GB RAM** (more than Oracle Cloud's 12 GB)
- **2 vCPU x86** (Oracle is ARM-only)
- **7 services** in a single container
- **Web terminal** (ttyd) — SSH alternative, free
- **Always-on** — UptimeRobot + cron-job.org keep-alive
- **Instant signup** — connect GitHub, deploy

## Services

| Service | URL Path | Port | Purpose |
|---------|----------|------|---------|
| GitAgent | `/` | 3333 | AI agent dashboard + API |
| n8n | `/n8n/` | 5678 | Workflow automation |
| PocketBase | `/pb/` | 8090 | Auth + quick database |
| Qdrant | `/qdrant/` | 6333 | Vector search + memory |
| ttyd | `/terminal/` | 7681 | Web terminal (SSH alternative) |
| Health | `/health` | 7860 | Keep-alive ping target |

## Quick Start

1. Create a Hugging Face account (free, no CC)
2. Create a new Space with `sdk: docker`
3. Upload all files from this repository
4. Set environment variables in Space Settings
5. Wait for build (~5-10 minutes)
6. Set up UptimeRobot + cron-job.org for keep-alive

## Keep-Alive Setup

**UptimeRobot** (primary):
- URL: `https://your-space.hf.space/health`
- Interval: 5 minutes

**cron-job.org** (backup):
- URL: `https://your-space.hf.space/health`
- Schedule: `*/10 * * * *`

## Environment Variables

See `.env.example` for all required and optional variables.

Required:
- `NEON_DATABASE_URL` — PostgreSQL database
- `GITHUB_TOKEN` — LLM API access (GitHub Models)

Optional (free tiers):
- `CF_R2_ENDPOINT` + `CF_R2_ACCESS_KEY_ID` + `CF_R2_SECRET_ACCESS_KEY` — Cloudflare R2 storage
- `COMPOSIO_API_KEY` — Tool integrations
- `N8N_WEBHOOK_URL` — n8n workflow notifications

## Architecture

```
Hugging Face Spaces (2 vCPU, 16 GB RAM)
├── Nginx (reverse proxy, port 7860)
├── GitAgent (AI agent runtime, port 3333)
├── n8n (workflow automation, port 5678)
├── PocketBase (auth + DB, port 8090)
├── Qdrant (vector search, port 6333)
├── ttyd (web terminal, port 7681)
└── keep-alive.sh (health monitor)
```

## vs Oracle Cloud

| Feature | Oracle Cloud Free | Ghost SuperComputer |
|---------|------------------|-------------------|
| RAM | 12 GB (ARM) | **16 GB (x86)** |
| Credit card | Required | **NOT required** |
| Signup | Minutes-days | **Instant** |
| Services | Just OS | **7 included** |
| Web terminal | None | **ttyd built-in** |
| Dashboards | 1 (complex) | **6 (simple)** |
| Agent runtime | None | **GitAgent built-in** |

## License

MIT
