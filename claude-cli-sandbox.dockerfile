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
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libncursesw5-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo
RUN userdel -r $(getent passwd ${UID} | cut -d: -f1) 2>/dev/null; \
  groupadd -f -g ${GID} ${USER} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER ${USER}
ENV HOME=/home/${USER}
WORKDIR ${HOME}

# Install nvm and Node.js
ENV NVM_DIR=${HOME}/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
  && . ${NVM_DIR}/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm cache clear
ENV PATH=${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}
RUN echo '\n# nvm' >> ${HOME}/.bashrc \
  && echo 'export NVM_DIR="${HOME}/.nvm"' >> ${HOME}/.bashrc \
  && echo '[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"' >> ${HOME}/.bashrc \
  && echo '[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"' >> ${HOME}/.bashrc

# Install pyenv and Python
ENV PYENV_ROOT=${HOME}/.pyenv
RUN curl -o- https://pyenv.run | bash \
  && ${PYENV_ROOT}/bin/pyenv install ${PYTHON_VERSION} \
  && ${PYENV_ROOT}/bin/pyenv global ${PYTHON_VERSION} \
  && ${PYENV_ROOT}/bin/pyenv versions --bare --skip-aliases | grep -v "^${PYTHON_VERSION}$" | xargs -r ${PYENV_ROOT}/bin/pyenv uninstall -f
ENV PATH=${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}
RUN echo '\n# pyenv' >> ${HOME}/.bashrc \
  && echo 'export PYENV_ROOT="${HOME}/.pyenv"' >> ${HOME}/.bashrc \
  && echo 'command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin:${PATH}"' >> ${HOME}/.bashrc \
  && echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc

# Install Go
ENV GOROOT=${HOME}/.go
ENV GOPATH=${HOME}/go
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -xz -C ${HOME} \
  && mv ${HOME}/go ${GOROOT}
ENV PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}

# Install Claude Code CLI (native, no Node dependency)
RUN curl -fsSL https://cli.claude.ai/install.sh | sh
ENV PATH=${HOME}/.claude/bin:${PATH}

# Mount points for host volumes
VOLUME ${HOME}/code
VOLUME ${HOME}/.claude
