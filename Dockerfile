FROM ghcr.io/moltbot/moltbot:main

USER root
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Create persistence structure
RUN mkdir -p /persistence/config /persistence/data \
    && chown -R node:node /persistence

USER node
WORKDIR /home/node

# Tool discovery paths
ENV PATH="/home/node/.local/bin:/home/node/.bun/bin:$PATH"
ENV UV_INSTALL_DIR="/home/node/.local"
ENV BUN_INSTALL="/home/node/.bun"

# Install package managers
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && curl -fsSL https://bun.sh/install | bash

# Install CLI tools
RUN uv tool install notebooklm-mcp-server \
    && uv tool install khal \
    && uv tool install vdirsyncer

# Prepare directories and create symlinks for persistence
RUN mkdir -p /home/node/.config /home/node/.local/share \
    && ln -s /persistence/config/vdirsyncer /home/node/.config/vdirsyncer \
    && ln -s /persistence/config/khal /home/node/.config/khal \
    && ln -s /persistence/config/notebooklm-mcp /home/node/.notebooklm-mcp \
    && ln -s /persistence/data/vdirsyncer /home/node/.local/share/vdirsyncer \
    && ln -s /persistence/data/khal /home/node/.local/share/khal

WORKDIR /app
