#!/bin/bash

git config --global user.email "bot@ghost-supercomputer.ai"
git config --global user.name "AutoSync Bot"

if [ ! -z "$HF_TOKEN" ]; then
    (
        while true; do
            sleep 1800
            cd /home/user/app
            git add .
            git diff-index --quiet HEAD || git commit -m "Auto-save $(date +%Y%m%d-%H%M)"
            git push https://user:${HF_TOKEN}@huggingface.co/spaces/${HF_USERNAME}/${HF_SPACE_NAME} main 2>/dev/null
        done
    ) &
fi

exec code-server --bind-addr 0.0.0.0:7860 --auth password /home/user/app
