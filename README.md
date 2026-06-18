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

### Run

```bash
make run CODE_DIR=/path/to/your/code
```

Or manually:

```bash
docker run -it \
  --name claude-cli-sandbox \
  -v /path/to/your/code:/home/dev/code \
  -v ~/.claude-config-sandbox:/home/dev/.claude-config \
  claude-cli-sandbox
```

- `--name claude-cli-sandbox` gives the container a fixed name instead of an auto-generated one
- `-it` starts the container in interactive mode with a terminal attached
- `-v /path/to/your/code:/home/dev/code` mounts your project directory into the container
- `-v ~/.claude-config-sandbox:/home/dev/.claude-config` persists Claude config and credentials on the host (the container sets `CLAUDE_CONFIG_DIR` to this path, keeping it separate from `~/.claude` where the CLI binary lives)

On first run, log in inside the container with `claude login`. Your session will persist across container restarts via the mounted volume.

### Start / Stop

After the first `make run`, the container already exists. On subsequent runs, start it directly without rebuilding:

```bash
make start
```

To stop the container:

```bash
make stop
```

To remove the container (e.g. before recreating it with different volumes):

```bash
make clean
```
