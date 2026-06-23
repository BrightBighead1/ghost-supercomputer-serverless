# ============================================================
# Ghost SuperComputer — Hugging Face Spaces Edition
# 15 services | 16 GB RAM + Modal GPU | $0/month
# ============================================================
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# ── 1. Install system dependencies ──────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git bash sudo procps jq unzip \
    nginx \
    supervisor \
    postgresql-client \
    default-mysql-client \
    redis-tools \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# ── 2. Build ttyd from source ──────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake g++ flex bison libjson-c-dev \
    libwebsockets-dev gengetopt libtool automake \
    && git clone https://github.com/nicm/ttyd.git /tmp/ttyd \
    && cd /tmp/ttyd \
    && mkdir build && cd build \
    && cmake .. \
    && make -j$(nproc) \
    && cp ttyd /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd \
    && rm -rf /tmp/ttyd \
    && apt-get purge -y cmake g++ flex bison gengetopt libtool automake \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# ── 3. Install Node.js 20 (for GitAgent + n8n) ─────────────
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ── 4. Install Python 3 + pip (for tools + Modal SDK) ──────
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# ── 5. Install AWS CLI v2 (for Cloudflare R2) ──────────────
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
    && cd /tmp && unzip -q awscliv2.zip \
    && ./aws/install --update 2>/dev/null \
    && rm -rf /tmp/aws /tmp/awscliv2.zip

# ── 6. Install Modal SDK ───────────────────────────────────
RUN pip3 install --break-system-packages modal

# ── 7. Install GitAgent ────────────────────────────────────
RUN npm install -g @open-gitagent/gitagent@latest

# ── 8. Install n8n ─────────────────────────────────────────
RUN npm install -g n8n

# ── 9. Install PocketBase ──────────────────────────────────
RUN PB_VERSION="0.25.1" \
    && curl -fsSL "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.tar.gz" \
    | tar xz -C /usr/local/bin pocketbase \
    && chmod +x /usr/local/bin/pocketbase

# ── 10. Install Qdrant ──────────────────────────────────────
RUN QDRANT_VERSION="v1.15.1" \
    && curl -fsSL "https://github.com/qdrant/qdrant/releases/download/${QDRANT_VERSION}/qdrant-x86_64-unknown-linux-gnu.tar.gz" \
    | tar xz -C /usr/local/bin qdrant \
    && chmod +x /usr/local/bin/qdrant

# ── 11. Create user and directories ─────────────────────────
RUN useradd -m -u 1000 -s /bin/bash ghost \
    && mkdir -p /app /data/pocketbase /data/qdrant /data/n8n \
    && chown -R ghost:ghost /app /data

# ── 12. Copy application files ─────────────────────────────
COPY --chown=ghost:ghost agent/ /app/agent/
COPY --chown=ghost:ghost scripts/ /app/scripts/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY --chown=ghost:ghost keep-alive.sh /app/keep-alive.sh
COPY --chown=ghost:ghost start.sh /app/start.sh

RUN chmod +x /app/keep-alive.sh /app/start.sh

# ── 13. Create nginx temp directories ──────────────────────
RUN mkdir -p /tmp/nginx/client_body /tmp/nginx/proxy \
    /tmp/nginx/fastcgi /tmp/nginx/uwsgi /tmp/nginx/scgi \
    && chown -R ghost:ghost /tmp/nginx

# ── 14. Set environment variables ──────────────────────────
ENV HOME=/home/ghost
ENV PATH=/home/ghost/.local/bin:$PATH
ENV HF_HOME=/data/huggingface
ENV GITAGENT_DIR=/app/agent
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV GENERIC_TIMEZONE=UTC
ENV TZ=UTC

# ── 15. Expose port 7860 (HF Spaces requirement) ───────────
EXPOSE 7860

# ── 16. Health check ───────────────────────────────────────
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:7860/health || exit 1

# ── 17. Start all services via supervisord ──────────────────
CMD ["/app/start.sh"]
