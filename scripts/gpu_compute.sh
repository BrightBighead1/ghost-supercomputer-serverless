#!/bin/bash
# gpu_compute.sh — Run heavy compute tasks on Modal GPU
INPUT=$(cat)
FUNCTION=$(echo "$INPUT" | grep -o '"function"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

if [ -z "$MODAL_TOKEN_ID" ] || [ -z "$MODAL_TOKEN_SECRET" ]; then
  echo '{"error": "Modal credentials not set"}'
  exit 1
fi

# Run Modal function
RESULT=$(modal run --token "$MODAL_TOKEN_ID" "$FUNCTION" 2>&1)

echo "{\"result\": \"$RESULT\"}"
