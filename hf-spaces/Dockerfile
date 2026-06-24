FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git wget sudo python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN su - user -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash'
RUN su - user -c 'export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" && nvm install --lts && nvm alias default lts/*'

RUN su - user -c 'pip3 install --no-cache-dir browser-use textgrad gradio_client'
RUN su - user -c 'playwright install chromium && playwright install-deps chromium'

USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:/home/user/.nvm/versions/node/*/bin:$PATH \
    NVM_DIR=/home/user/.nvm

WORKDIR $HOME/app
EXPOSE 7860

COPY --chown=user:1000 entrypoint.sh /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

ENTRYPOINT ["/home/user/entrypoint.sh"]
