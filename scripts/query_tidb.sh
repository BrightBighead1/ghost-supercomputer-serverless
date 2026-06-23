#!/bin/bash
# query_tidb.sh — Execute SQL against TiDB Cloud Serverless
INPUT=$(cat)
SQL_QUERY=$(echo "$INPUT" | grep -o '"query"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

if [ -z "$TIDB_HOST" ] || [ -z "$TIDB_USER" ] || [ -z "$TIDB_PASSWORD" ]; then
  echo '{"error": "TiDB credentials not set"}'
  exit 1
fi

RESULT=$(mysql -h "$TIDB_HOST" -P "${TIDB_PORT:-4000}" -u "$TIDB_USER" -p"$TIDB_PASSWORD" "$TIDB_DATABASE" -e "$SQL_QUERY" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "{\"error\": \"$RESULT\"}"
else
  echo "{\"result\": \"$RESULT\", \"rows\": $(echo "$RESULT" | wc -l)}"
fi
