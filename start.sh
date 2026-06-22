#!/bin/bash
# start.sh — Initialize and launch Ghost SuperComputer
set -e

echo "============================================"
echo "  Ghost SuperComputer — HF Spaces Edition"
echo "  7 services | 16 GB RAM | \$0/month"
echo "============================================"

# ── Create required directories ────────────────────────────
mkdir -p /data/pocketbase /data/qdrant /data/n8n
chown -R ghost:ghost /data /app

# ── Initialize PocketBase (first run only) ─────────────────
if [ ! -f /data/pocketbase/pb_data/data.db ]; then
    echo "[start] Initializing PocketBase database..."
    su -s /bin/bash ghost -c "pocketbase migrate --dir=/data/pocketbase" 2>/dev/null || true
fi

# ── Print service URLs ────────────────────────────────────
echo ""
echo "[start] Service URLs:"
echo "[start]   Dashboard:    http://${SPACE_HOST:-localhost}/"
echo "[start]   GitAgent:     http://${SPACE_HOST:-localhost}/agent/"
echo "[start]   n8n:          http://${SPACE_HOST:-localhost}/n8n/"
echo "[start]   PocketBase:   http://${SPACE_HOST:-localhost}/pb/"
echo "[start]   Qdrant:       http://${SPACE_HOST:-localhost}/qdrant/"
echo "[start]   Terminal:     http://${SPACE_HOST:-localhost}/terminal/"
echo "[start]   Health:       http://${SPACE_HOST:-localhost}/health"
echo ""

# ── Launch all services via supervisord ────────────────────
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
