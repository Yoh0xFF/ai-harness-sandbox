# AI Harness Sandbox

Sandbox environment for the AI harness software

## Claude CLI Sandbox

A Docker-based sandbox environment with Node.js (nvm), Python (pyenv), Go, and the Claude Code CLI pre-installed.

### Build

```bash
make build
```

This tags the image as both `claude-cli-sandbox:latest` and `claude-cli-sandbox:<timestamp>` (e.g. `20260618-143052`).

To customize the build (e.g. match your host UID/GID), pass build args directly:

```bash
docker build -f claude-cli-sandbox.dockerfile \
  -t claude-cli-sandbox:latest \
  -t claude-cli-sandbox:$(date +%Y%m%d-%H%M%S) \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  .
```

### Create Container

```bash
make create CODE_DIR=/path/to/your/code
```

- `-v /path/to/your/code:/home/dev/code` mounts your project directory into the container
- `-v ~/.claude-config-sandbox:/home/dev/.claude-config` persists Claude config and credentials on the host (the container sets `CLAUDE_CONFIG_DIR` to this path, keeping it separate from `~/.claude` where the CLI binary lives)

### Start / Stop / Remove

Start the container and attach to it:

```bash
docker start -ai claude-cli-sandbox
```

Stop the container:

```bash
docker stop claude-cli-sandbox
```

Remove the container (e.g. before recreating it with different volumes):

```bash
make clean
```

On first run, log in inside the container with `claude login`. Your session will persist across container restarts via the mounted volume.
