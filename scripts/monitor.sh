#!/bin/bash
# Ghost SuperComputer monitoring script

echo "=== Ghost SuperComputer Monitor ==="
echo ""
echo "--- Memory ---"
free -h
echo ""
echo "--- Disk ---"
df -h ~
echo ""
echo "--- Processes ($(ps aux | wc -l) / 150 max) ---"
echo ""
echo "--- Containers ---"
podman stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "No containers running"
echo ""
echo "=== $(date) ==="
