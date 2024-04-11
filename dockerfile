# Ubuntu image
FROM ubuntu:22.04

# Prompts are boring 
ARG DEBIAN_FRONTEND=noninteractive

# Run Ubuntu boiler plate code
RUN apt-get update && apt-get install -y software-properties-common

# Install development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    binutils \
    tree \
    neovim \
    python3 \
    python3-pip \
    graphviz \
    postgresql postgresql-contrib

# Install Dockersception for PostgreSQL
RUN apt-get update && apt-get install -y docker.io

# Move requirements.txt
COPY requirements.txt /tmp/requirements.txt

# Install Python packages
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt