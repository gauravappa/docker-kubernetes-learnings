# Container lifecycle

**Date:** 2026-05-31  
**Status:** draft

## Overview

A container moves through a small set of states—from created, to running, to stopped, to removed. Knowing those states and the matching `docker` commands makes it easier to debug apps and clean up after experiments.

Builds on: [Why containers?](../why-containers/README.md), [VMs vs containers](../vm-vs-containers/README.md).

## Goal

Map Docker container **states** to **CLI commands**: what `docker run` does under the hood, what you can do while a container is running or stopped, and how stop differs from kill.

## Prerequisites

- Docker installed and the daemon running
- Familiarity with [why containers](../why-containers/README.md) (optional)

## `docker run` = create + start

`docker run` is shorthand for two steps:

1. **Create** a container from an image (`docker create`)
2. **Start** that container (`docker start`)

You can run those steps separately—useful when you want to create a container with a name or options first, then start it later.

```bash
docker create --name web nginx:alpine
docker start web
```

`docker run` does both in one command.

## States and what you can do

### Created → running

- **`docker start <container>`** moves a created or stopped container into **running**.
- While **running**, common operations:
  - **`docker logs`** — view stdout/stderr
  - **`docker inspect`** — read metadata (IP, mounts, env, state)
  - **`docker exec`** — run a command inside the running container (interactive shell, one-off command)
  - **`docker pause` / `docker unpause`** — freeze the process; **memory stays as-is**; on unpause execution continues from where it paused

### Running → stopped

- **`docker stop <container>`** — **graceful** shutdown: sends SIGTERM, waits for a timeout, then SIGKILL if the process does not exit in time.
- **`docker kill <container>`** — **immediate** force stop (like SIGKILL); no graceful window.

After stop, the container is in the **stopped** (exited) state. It still exists on disk; only the main process is not running.

### Stopped

While **stopped**, you can still:

- **`docker logs`** — read logs from the last run
- **`docker inspect`** — inspect configuration and exit code
- **`docker start`** — start again (same container, same filesystem layer unless you removed volumes)
- **`docker rm`** — **remove** the container record (must be stopped, or use `-f` to force)

To “restart” in one step from running: **`docker restart`** (stop + start).

## Lifecycle at a glance

```
image ──create──► created ──start──► running ──stop/kill──► stopped ──rm──► removed
                      ▲                    │                      │
                      └──── start ─────────┘                      │
                      └──────────────── restart ──────────────────┘
```

| State | Typical commands |
|-------|------------------|
| Created | `docker start` |
| Running | `logs`, `inspect`, `exec`, `pause` / `unpause`, `stop`, `kill` |
| Stopped | `logs`, `inspect`, `start`, `rm` |

## Examples in this folder

| File | Purpose |
|------|---------|
| *(none)* | Conceptual notes—pair with hands-on `docker run` / `docker ps` practice |

## Takeaways

- **`docker run`** = create + start; **`create`** and **`start`** can be used on their own.
- **Running**: inspect, exec, logs; **pause** keeps memory state until **unpause**.
- **`stop`** is graceful with a timeout; **`kill`** stops immediately.
- **Stopped** containers remain for logs/inspect; **`start`** runs them again, **`rm`** deletes them.
- Images stay on the host after `rm`; removing a container does not remove the image.

## References

- [docker container run](https://docs.docker.com/reference/cli/docker/container/run/)
- [docker container stop / kill](https://docs.docker.com/reference/cli/docker/container/stop/)
- Aligns with course exercises on running containers and Docker CLI (start, stop, rm).
