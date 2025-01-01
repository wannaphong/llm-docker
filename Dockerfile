# Specify the correct NVIDIA CUDA image with CUDNN and development tools
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Install system packages
RUN apt update && apt install -y \
    git \
    wget \
    openmpi-bin \
    openmpi-doc \
    libopenmpi-dev \
    zip \
    unzip
RUN mkdir /workspace
RUN useradd -u 8877 wannaphongp
RUN chown -R wannaphongp:wannaphongp /workspace
# Install Miniconda

# Change to non-root privilege
USER wannaphongp

WORKDIR /workspace
RUN mkdir -p /workspace/miniconda3 \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /workspace/miniconda3/miniconda.sh \
    && bash /workspace/miniconda3/miniconda.sh -b -u -p /workspace/miniconda3 \
    && rm /workspace/miniconda3/miniconda.sh \
    && /workspace/miniconda3/bin/conda init bash

# Setting the PATH environment variable for conda
ENV PATH /workspace/miniconda3/bin:$PATH
ENV CUDNN_FRONTEND_PATH /workspace/cudnn-frontend/include

# Clone necessary repositories to the home directory
RUN wget https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v1.7.0.zip && unzip v1.7.0.zip -d cudnn-frontend && ls cudnn-frontend
RUN git clone https://github.com/wannaphong/llm.c /workspace/llmc
WORKDIR /workspace/llmc
RUN CUDNN_FRONTEND_PATH=/workspace/cudnn-frontend/include make train_gpt2cu
