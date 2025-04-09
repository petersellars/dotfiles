# Use the official Microsoft Ubuntu 24.04 image as a base
FROM mcr.microsoft.com/vscode/devcontainers/base:1.2.5-ubuntu-24.04

# Install Python 3 Pip
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Clone the adr-tools repository
RUN git clone https://github.com/npryce/adr-tools.git /opt/adr-tools

# Add adr-tools to the PATH
ENV PATH="/opt/adr-tools/src:${PATH}"

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]
