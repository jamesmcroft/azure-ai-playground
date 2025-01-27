# Use a base image that supports CUDA.
FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

# Install additional tools and dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    poppler-utils \
    tesseract-ocr \
    libtesseract-dev \
    ffmpeg \
    libsm6 \
    libxext6 \
    software-properties-common \
    python3-dev \
    python3-pip \
    python3-opencv \
    python3-wheel \
    python3-setuptools

RUN pip install --upgrade pip \
    && pip install --no-cache-dir \
    packaging \
    matplotlib \
    transformers \
    pillow \
    torch

# Default to bash shell
ENV SHELL=/bin/bash \
    DOCKER_BUILDKIT=1

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]
