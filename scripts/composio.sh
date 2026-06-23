#!/bin/bash
# composio.sh — Execute Composio tool integrations
INPUT=$(cat)
APP=$(echo "$INPUT" | grep -o '"app"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
ACTION=$(echo "$INPUT" | grep -o '"action"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

if [ -z "$COMPOSIO_API_KEY" ]; then
  echo '{"error": "COMPOSIO_API_KEY not set"}'
  exit 1
fi

RESULT=$(curl -s -X POST "https://api.composio.dev/execute" \
  -H "x-api-key: ${COMPOSIO_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"app\": \"$APP\", \"action\": \"$ACTION\"}" 2>&1)

echo "$RESULT"
