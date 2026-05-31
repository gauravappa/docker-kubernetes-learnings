# Note template (topic README.md)

**Read [user-conventions.md](user-conventions.md) → Writing format first.** User-required sections and style override this template. When the user specifies format preferences, update `user-conventions.md` and align this file per [conventions-workflow.md](conventions-workflow.md).

Default: copy this structure into each topic folder's `README.md` (or the filename defined in user conventions). Delete sections that do not apply.

```markdown
# <Topic title>

**Date:** YYYY-MM-DD  
**Status:** draft | practiced | confident

## Overview

One or two sentences: what this topic covers and why you explored it.

## Goal

What you set out to learn or verify (one short paragraph or bullet list).

## Prerequisites

- Tools/versions (e.g. Docker 27.x, kind 0.24, kubectl 1.32)
- Prior topics or clusters already running

## Steps

Numbered steps you actually performed. Each step: brief explanation, then command or config reference.

### 1. <Step name>

```bash
# commands you ran
```

What happened and what to notice.

### 2. <Step name>

...

## Examples in this folder

| File | Purpose |
|------|---------|
| [examples/Dockerfile](examples/Dockerfile) | ... |
| [examples/docker-compose.yaml](examples/docker-compose.yaml) | ... |

Embed small snippets only when it aids reading; link to files for full configs.

## Observations

- What surprised you, failed first, or needed a retry
- Differences from docs or between local vs cluster behavior

## Takeaways

- Bullet 1 — concrete, actionable
- Bullet 2
- Bullet 3

## References

- [Official doc title](https://docs.docker.com/...) or Kubernetes docs link
```

## Style rules

- **Present tense** for facts ("The Service routes traffic to pods"); **past tense** for your session ("Built the image with `--no-cache`").
- **Commands**: full flags you used; avoid `...` unless repeating obvious flags.
- **No secrets** in notes or examples; use placeholders (`<REGISTRY>`, `<TOKEN>`).
- **Headings**: do not skip levels (H1 once, then H2, H3).
- **Length**: aim 50–120 lines; split topic if longer.

## Example (filled, abbreviated)

```markdown
# Run a container and publish a port

**Date:** 2026-05-31  
**Status:** practiced

## Overview

Run an nginx container locally and reach it from the host via port mapping.

## Goal

Understand `-p host:container` and verify the process inside the container.

## Prerequisites

- Docker Desktop or Docker Engine running

## Steps

### 1. Pull and run nginx

```bash
docker run -d --name web -p 8080:80 nginx:alpine
```

Container listens on 80 inside; host `localhost:8080` forwards to it.

### 2. Verify

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
```

Expect `200`.

## Examples in this folder

| File | Purpose |
|------|---------|
| (none — commands only for this topic) | |

## Takeaways

- `-p` maps host port to container port; omit either side only when you know the default behavior.
- Container name `--name` simplifies `docker logs web` and stop/remove.

## References

- [Docker run reference](https://docs.docker.com/reference/cli/docker/container/run/)
```
