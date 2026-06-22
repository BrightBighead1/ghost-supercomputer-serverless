# Ghost SuperComputer

$0/month AI agent hosting platform. No credit card required.

## What You Get

- **16 GB RAM** — more than Oracle Cloud's 12 GB
- **2 vCPU x86** — Oracle is ARM-only
- **7 services** — all running in one container
- **Web terminal** — ttyd, free SSH alternative
- **Always-on** — UptimeRobot + cron-job.org
- **Instant signup** — no credit card, no waiting

## Services

| Service | URL | Purpose |
|---------|-----|---------|
| GitAgent | `/` | AI agent dashboard |
| n8n | `/n8n/` | Workflow automation |
| PocketBase | `/pb/` | Auth + quick DB |
| Qdrant | `/qdrant/` | Vector search |
| ttyd | `/terminal/` | Web terminal |
| Health | `/health` | Keep-alive target |

## Quick Start

1. Create HF account (free)
2. Create Space with `sdk: docker`
3. Upload files
4. Set env vars in Settings
5. Wait for build
6. Set up UptimeRobot + cron-job.org

## Keep-Alive

**UptimeRobot** (5 min): `https://your-space.hf.space/health`
**cron-job.org** (10 min): `https://your-space.hf.space/health`

## vs Oracle Cloud

| Feature | Oracle | Ghost |
|---------|--------|-------|
| RAM | 12 GB | **16 GB** |
| CPU | ARM | **x86** |
| Credit card | Required | **No** |
| Signup | Days | **Instant** |
| Services | OS only | **7 included** |
| Terminal | SSH | **ttyd** |

## License

MIT
