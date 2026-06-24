#!/bin/bash
# Ghost SuperComputer watchdog — restarts failed containers

podman ps --format "{{.Names}}" 2>/dev/null | while read name; do
  status=$(podman inspect --format '{{.State.Status}}' "$name" 2>/dev/null)
  if [ "$status" != "running" ]; then
    podman start "$name" 2>/dev/null
    echo "$(date): Restarted $name" >> ~/logs/watchdog.log
  fi
done
