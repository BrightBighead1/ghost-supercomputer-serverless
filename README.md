---
title: Ghost SuperComputer
emoji: 👻
colorFrom: purple
colorTo: blue
sdk: docker
app_port: 7860
---

# Ghost SuperComputer v3.0

**$0/month | 35 Tools | Self-Evolving | Revenue-Generating**

An AI supercomputer running on free-tier infrastructure across 6 platforms.

## Architecture

```
freeshell.de VPS (4GB) ──→ Cloudflare Tunnel ──→ Cloudflare Edge
     │
     ├── CowAgent (agent brain)
     ├── OmniRoute (231 LLM providers)
     ├── Qdrant (vector DB)
     ├── n8n (workflows)
     ├── PocketBase (document DB)
     ├── Uptime Kuma (monitoring)
     └── ttyd (web terminal)

HF Spaces (16GB) ──→ GPU compute
     ├── code-server (VS Code)
     ├── browser-use (web automation)
     ├── TextGrad (prompt optimization)
     └── CORAL (multi-agent evolution)

Northflank (24/7) ──→ Persistent services
     ├── Custom MCP Server
     └── PostgreSQL

PandaStack (24/7) ──→ Static sites + containers

Modal ──→ GPU on-demand ($30/mo free)
```

## Quick Start

1. See [DEPLOY.md](DEPLOY.md) for full deployment guide
2. See [vps/](vps/) for VPS docker-compose
3. See [hf-spaces/](hf-spaces/) for Hugging Face setup

## License

MIT
