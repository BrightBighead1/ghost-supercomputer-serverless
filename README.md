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

$0/month AI supercomputer. No credit card required. Beats Oracle Cloud Free Tier.

## What You Get

| Resource | Oracle Cloud Free | Ghost SuperComputer |
|----------|------------------|-------------------|
| RAM | 12 GB (ARM) | **16 GB + Modal GPU** |
| CPU | 4 OCPU ARM | **2 vCPU x86** |
| Storage | 200 GB | **15.5 GB cloud + 50 GB disk** |
| Databases | 1 (ATP) | **3 (Neon + TiDB + PocketBase)** |
| Vector DB | None | **Qdrant Cloud + Local** |
| Workflows | None | **n8n Cloud** |
| Web Terminal | None | **ttyd** |
| LLM API | None | **GitHub Models** |
| Credit card | Required | **NOT required** |

## 15 Services Running

| # | Service | Free Tier | Purpose |
|---|---------|-----------|---------|
| 1 | Hugging Face Spaces | 16 GB RAM, 2 vCPU | Primary compute |
| 2 | Neon Database | 0.5 GB PostgreSQL | Primary database |
| 3 | TiDB Cloud Serverless | 5 GB MySQL/HTAP | Secondary database |
| 4 | Qdrant Cloud | 1 GB vectors | Vector search |
| 5 | Modal | $30/mo compute | Heavy GPU tasks |
| 6 | Cloudflare R2 | 10 GB storage | File storage |
| 7 | n8n Cloud | 5 workflows | Automation |
| 8 | PocketBase | Local SQLite | Auth + quick DB |
| 9 | Qdrant Local | Local storage | Fast vector cache |
| 10 | Composio | 1K executions | Tool integrations |
| 11 | GitHub Models | gpt-4o-mini | LLM inference |
| 12 | Firecrawl | 1K pages/mo | Web scraping |
| 13 | UptimeRobot | 50 monitors | Keep-alive #1 |
| 14 | cron-job.org | 50 jobs | Keep-alive #2 |
| 15 | ttyd | Local | Web terminal |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    GHOST SUPERCOMPUTER                          │
│                    $0/month | 16 GB RAM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  HF Spaces Container (2 vCPU, 16 GB RAM, 50 GB disk)    │  │
│  │                                                           │  │
│  │  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌───────────┐  │  │
│  │  │  Nginx  │  │ GitAgent │  │   n8n   │  │ PocketBase│  │  │
│  │  │ :7860   │──│  :3333   │──│  :5678  │──│   :8090   │  │  │
│  │  └─────────┘  └──────────┘  └─────────┘  └───────────┘  │  │
│  │       │              │            │             │         │  │
│  │  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌───────────┐  │  │
│  │  │  ttyd   │  │  Qdrant  │  │ keep-   │  │   tools/  │  │  │
│  │  │ :7681   │  │  :6333   │  │  alive  │  │  scripts  │  │  │
│  │  └─────────┘  └──────────┘  └─────────┘  └───────────┘  │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                  │
│         ┌────────────────────┼────────────────────┐             │
│         │                    │                    │             │
│         ▼                    ▼                    ▼             │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐       │
│  │  Neon DB    │  │ TiDB Cloud   │  │ Qdrant Cloud    │       │
│  │  0.5 GB     │  │  5 GB        │  │  1 GB           │       │
│  │  PostgreSQL │  │  MySQL/HTAP  │  │  Vectors        │       │
│  └─────────────┘  └──────────────┘  └─────────────────┘       │
│         │                    │                    │             │
│         ▼                    ▼                    ▼             │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐       │
│  │ Cloudflare  │  │    Modal     │  │   Composio      │       │
│  │ R2 10 GB    │  │  $30/mo GPU  │  │  1K exec/mo     │       │
│  └─────────────┘  └──────────────┘  └─────────────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Total Free Resources

| Resource | Amount |
|----------|--------|
| RAM | 16 GB (HF) + Modal GPU |
| CPU | 2 vCPU x86 + Modal |
| Storage | 50 GB disk + 15.5 GB cloud |
| PostgreSQL | 0.5 GB (Neon) |
| MySQL/HTAP | 5 GB (TiDB) |
| SQLite | Unlimited (local) |
| Vector DB | 1 GB (Qdrant Cloud) + Local |
| File Storage | 10 GB (Cloudflare R2) |
| Workflows | 5 (n8n Cloud) |
| LLM Queries | Unlimited (GitHub Models) |
| Web Scraping | 1K pages/mo (Firecrawl) |
| Tool Executions | 1K/mo (Composio) |
| Keep-Alive | Unlimited (UptimeRobot + cron-job.org) |
| **Total** | **$0/month** |

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
- `TIDB_HOST` + `TIDB_USER` + `TIDB_PASSWORD` — TiDB Cloud (5 GB)
- `QDRANT_CLOUD_URL` + `QDRANT_CLOUD_API_KEY` — Qdrant Cloud (1 GB)
- `MODAL_TOKEN_ID` + `MODAL_TOKEN_SECRET` — Modal GPU ($30/mo)
- `CF_R2_ENDPOINT` + `CF_R2_ACCESS_KEY_ID` + `CF_R2_SECRET_ACCESS_KEY` — Cloudflare R2 (10 GB)
- `N8N_WEBHOOK_URL` — n8n workflow notifications
- `COMPOSIO_API_KEY` — Tool integrations
- `FIRECRAWL_API_KEY` — Web scraping

## License

MIT
