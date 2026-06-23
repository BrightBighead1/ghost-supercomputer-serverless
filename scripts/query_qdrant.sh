#!/bin/bash
# query_qdrant.sh — Search local Qdrant vector database
INPUT=$(cat)
COLLECTION=$(echo "$INPUT" | grep -o '"collection"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
LIMIT=$(echo "$INPUT" | grep -o '"limit"[[:space:]]*:[[:space:]]*[0-9]*' | grep -o '[0-9]*')

LIMIT=${LIMIT:-10}

RESULT=$(curl -s -X POST "http://127.0.0.1:6333/collections/${COLLECTION}/points/search" \
  -H "Content-Type: application/json" \
  -d "{\"vector\": [0.1, 0.2, 0.3], \"limit\": $LIMIT}" 2>&1)

echo "$RESULT"
