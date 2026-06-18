# Ubuntu LTS version
FROM ubuntu:26.04

ARG USER=dev
ARG UID=1000
ARG GUID=1000

ARG NODE_VERSION=22.22.3
ARG PYTHON_VERSPN=3.14.2
ARG GO_VERSION=1.26.4

# System layer (root)
RUN apt-get update && apt-get install -y --no-install-recommends \ 
  ca-certificates curl git sudo build-essential
