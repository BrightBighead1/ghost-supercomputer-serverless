#!/bin/bash
# keep-alive.sh — Health monitor for Ghost SuperComputer
# External keep-alive handled by UptimeRobot (5min) + cron-job.org (10min)

INTERVAL=${KEEP_ALIVE_INTERVAL:-300}

echo "[keep-alive] $(date -u '+%Y-%m-%d %H:%M:%S') — Ghost SuperComputer health monitor started"
echo "[keep-alive] External keep-alive: UptimeRobot (5min) + cron-job.org (10min)"

while true; do
    HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:7860/health" 2>/dev/null || echo "000")
    GITAGENT_CODE=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:3333/" 2>/dev/null || echo "000")
    N8N_CODE=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:5678/healthz" 2>/dev/null || echo "000")
    PB_CODE=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:8090/api/health" 2>/dev/null || echo "000")
    QDRANT_CODE=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:6333/healthz" 2>/dev/null || echo "000")

    echo "[keep-alive] $(date -u '+%Y-%m-%d %H:%M:%S') | nginx:${HTTP_CODE} | gitagent:${GITAGENT_CODE} | n8n:${N8N_CODE} | pocketbase:${PB_CODE} | qdrant:${QDRANT_CODE}"

    curl -sS -o /dev/null "http://127.0.0.1:7860/health" 2>/dev/null || true

    sleep ${INTERVAL}
done
