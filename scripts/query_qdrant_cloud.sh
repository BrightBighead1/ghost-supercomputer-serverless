#!/bin/bash
# query_qdrant_cloud.sh — Search Qdrant Cloud vector database
INPUT=$(cat)
COLLECTION=$(echo "$INPUT" | grep -o '"collection"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
LIMIT=$(echo "$INPUT" | grep -o '"limit"[[:space:]]*:[[:space:]]*[0-9]*' | grep -o '[0-9]*')

LIMIT=${LIMIT:-10}

if [ -z "$QDRANT_CLOUD_URL" ] || [ -z "$QDRANT_CLOUD_API_KEY" ]; then
  echo '{"error": "Qdrant Cloud credentials not set"}'
  exit 1
fi

RESULT=$(curl -s -X POST "${QDRANT_CLOUD_URL}/collections/${COLLECTION}/points/search" \
  -H "Content-Type: application/json" \
  -H "api-key: ${QDRANT_CLOUD_API_KEY}" \
  -d "{\"vector\": [0.1, 0.2, 0.3], \"limit\": $LIMIT}" 2>&1)

echo "$RESULT"
