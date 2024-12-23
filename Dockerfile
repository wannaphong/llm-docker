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

# Install Miniconda
RUN mkdir -p ~/miniconda3 \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh \
    && bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 \
    && rm ~/miniconda3/miniconda.sh \
    && ~/miniconda3/bin/conda init bash

# Setting the PATH environment variable for conda
ENV PATH /root/miniconda3/bin:$PATH
ENV CUDNN_FRONTEND_PATH /root/cudnn-frontend/include

# Clone necessary repositories to the home directory
RUN wget https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v1.7.0.zip && unzip v1.7.0.zip -d cudnn-frontend && ls cudnn-frontend
RUN git clone https://github.com/wannaphong/llm.c ~/llmc
WORKDIR ~/llmc
