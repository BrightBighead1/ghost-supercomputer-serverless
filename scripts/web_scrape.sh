#!/bin/bash
# web_scrape.sh — Scrape web pages using Firecrawl API
INPUT=$(cat)
URL=$(echo "$INPUT" | grep -o '"url"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
FORMAT=$(echo "$INPUT" | grep -o '"format"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

FORMAT=${FORMAT:-"markdown"}

if [ -z "$FIRECRAWL_API_KEY" ]; then
  echo '{"error": "FIRECRAWL_API_KEY not set"}'
  exit 1
fi

RESULT=$(curl -s -X POST "https://api.firecrawl.dev/v1/scrape" \
  -H "Authorization: Bearer ${FIRECRAWL_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"url\": \"$URL\", \"formats\": [\"$FORMAT\"]}" 2>&1)

echo "$RESULT"
