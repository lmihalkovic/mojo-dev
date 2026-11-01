# NVIDIA CUDA base image for GPU support
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies and Python
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    python3.11-venv \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set PATH to include uv
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /workspace

# Install Mojo, PyTorch, Jupyter, and JupyterLab using uv
RUN uv pip install \
    --python 3.11 \
    mojo \
    torch \
    jupyter \
    jupyterlab \
    ipykernel

# Create Jupyter config directory
RUN mkdir -p /root/.jupyter

# Configure Jupyter to allow root access
RUN echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py

# Expose Jupyter port
EXPOSE 8888

# Verify Mojo installation
RUN mojo --version

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
