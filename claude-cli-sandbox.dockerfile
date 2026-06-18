# Ubuntu LTS version
FROM ubuntu:26.04

# User details
ARG USER=dev
ARG UID=1000
ARG GID=1000

# Developer tool versions 
ARG NODE_VERSION=22.22.3
ARG PYTHON_VERSION=3.14.2
ARG GO_VERSION=1.26.4

# System layer (root)
RUN apt-get update && apt-get install -y --no-install-recommends \ 
  ca-certificates curl git sudo build-essential \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo
RUN groupadd -g ${GID} ${USER} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
