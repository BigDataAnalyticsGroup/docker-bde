# Ubuntu image
FROM ubuntu:22.04

# Set username
ENV USERNAME=bde

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
    postgresql \
    postgresql-contrib \
    libssl-dev

# Install Dockersception for PostgreSQL
RUN apt-get update && apt-get install -y docker.io

# Create user
RUN useradd -s /bin/sh -d /home/$USERNAME -m $USERNAME

# Add .local/bin to PATH
RUN if ! $(grep -Fxq 'export PATH="$PATH:/home/$USERNAME/.local/bin"' /etc/profile); \
    then \
        echo 'export PATH="$PATH:/home/$USERNAME/.local/bin"' >> /etc/profile; \
    fi

# Switch user
USER $USERNAME

# Install Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --user -r /tmp/requirements.txt

# Install Jupyter extensions and adapt PATH to find Jupyter
ENV PATH="${PATH}:/home/$USERNAME/.local/bin"
RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable varInspector/main