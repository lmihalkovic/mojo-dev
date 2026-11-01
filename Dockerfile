# Start from RunPod/NVIDIA-compatible CUDA base image
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# Prevent interactive prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/share/magic/bin:${PATH}"

# Install core utilities
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install the Modular Magic CLI
RUN curl -ssL https://magic.modular.com/ | bash

# Create and configure the workspace directory
WORKDIR /workspace

# Initialize the mojo environment structure 
RUN magic init gpu-playground --format mojoproject

# Step into the environment directory to pin and fetch the Mojo tools
WORKDIR /workspace/gpu-playground
RUN magic add mojo

# Pre-warm the environment cache by installing Mojo into the layer
RUN magic run mojo --version

# Set bash to automatically load into the magic environment upon connection
RUN echo "cd /workspace/gpu-playground && magic shell" >> /root/.bashrc

# Ensure RunPod lands inside the container's interactive shell
ENTRYPOINT ["/bin/bash"]
