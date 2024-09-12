# Use the official Microsoft Ubuntu 24.04 image as a base
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Clone the adr-tools repository
RUN git clone https://github.com/npryce/adr-tools.git /opt/adr-tools

# Add adr-tools to the PATH
ENV PATH="/opt/adr-tools/src:${PATH}"

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]
