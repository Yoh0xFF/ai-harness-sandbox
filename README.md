# ai-harness-sandbox
Sandbox environment for the AI harness software

## Claude CLI Sandbox

A Docker-based sandbox environment with Node.js (nvm), Python (pyenv), Go, and the Claude Code CLI pre-installed.

### Build

```bash
docker build -t claude-cli-sandbox -f claude-cli-sandbox.dockerfile .
```

To customize the build (e.g. match your host UID/GID):

```bash
docker build -t claude-cli-sandbox -f claude-cli-sandbox.dockerfile \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  .
```

### Run

```bash
docker run -it \
  -v /path/to/your/code:/home/dev/code \
  -v ~/.claude-yoh:/home/dev/.claude-config \
  claude-cli-sandbox
```

- `-it` starts the container in interactive mode with a terminal attached
- `-v /path/to/your/code:/home/dev/code` mounts your project directory into the container
- `-v ~/.claude-yoh:/home/dev/.claude-config` mounts your Claude config/credentials directory (the container sets `CLAUDE_CONFIG_DIR` to this path, keeping it separate from `~/.claude` where the CLI binary lives)
