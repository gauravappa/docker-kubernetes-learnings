# Why containers?

**Date:** 2026-05-31  
**Status:** draft

## Overview

Containers exist because **deploying apps on servers used to be slow and fragile**. This note compares the old model (install everything on each machine) with the container model (run a pre-built image), so the rest of the Docker topics in this repo have context.

After reading this page you should understand:

- The usual steps in a traditional deployment
- Why the developer–DevOps script loop was painful
- What a container improves (portability, limits, scaling)
- What still gets handed to operations (configuration, not install scripts)

## Goal

Record the **why** behind Docker before the first `docker run`: what broke in traditional deployment, and how images change the workflow.

## Prerequisites

- None (conceptual). Hands-on exercises come next under `docker/fundamentals/`.

## Traditional deployment

On a bare server or VM, getting an app running typically meant:

1. Install **dependencies** for the runtime (system packages, libraries).
2. Install and configure the **runtime** (Node, Python, JVM, etc.).
3. Deploy **application code** and **configuration** (env vars, config files, secrets).
4. **Start** the process and verify it stays up.

### The pain loop

A common pattern:

1. Developer writes an install or setup **script** and hands it to DevOps.
2. DevOps runs it on the server; something fails (missing package, wrong path, different OS).
3. Developer changes the script; DevOps tries again.
4. Repeat until production works.

Each environment—laptop, staging, production—can **drift**. That is the root of *“works on my machine, not on the server.”*

## Why containers

A **container** runs an **image**: a packaged filesystem that already includes the app, its dependencies, and much of the configuration needed to start. The host only needs a container runtime (e.g. Docker), not a full manual install of your stack on every machine.

| Traditional pain | What containers change |
|------------------|-------------------------|
| Environments drift | Same **image** on laptop, CI, and production |
| Long per-server installs | **Run an image** instead of re-installing stacks everywhere |
| “Works on my machine” | App + runtime deps live **inside** the image boundary |
| Noisy neighbors | **CPU/memory limits** per container on a shared host |
| Scaling = redoing setup | Scale by running **another instance** of the image (plus ports, env, orchestration) |

Containers do **not** remove configuration—you still set ports, env vars, secrets, and orchestration—but they move “install the world on this server” into “build once, run the image.”

## How the handoff changes

| | Traditional | With containers |
|---|-------------|-----------------|
| **Developer ships** | Install scripts + documentation | **Image** + how to configure it |
| **Operations runs** | Script on each server; debug missing deps | **Image** with compose, env, or orchestration manifests |
| **Typical friction** | Many back-and-forth fixes on the server | Fewer surprises from missing OS packages (they belong in the image build) |

**Before:** too much to-and-fro fixing scripts on the server.  
**After:** developer provides an image and configuration; operations runs that image.

**Next in this repo:** pull an image and run your first container (add a note under `docker/fundamentals/` when you complete that exercise).

## Examples in this folder

| File | Purpose |
|------|---------|
| *(none)* | Conceptual notes only—no configs yet |

## Observations

- The shift is as much about **process** (what you hand off) as about technology.
- Scaling is “one more instance of the same image,” not “run the install script again on a new box.”
- You still need discipline for secrets, env-specific config, and orchestration later (Compose, Kubernetes).

## Takeaways

- Traditional deployment repeats install + configure steps on every server; scripts break when environments differ.
- An **image** bundles app, dependencies, and runtime expectations; a **container** is a running instance of that image.
- Portability and resource limits address drift and noisy-neighbor problems on shared hosts.
- Scaling often means running another container from the same image, not re-running bespoke installs.
- Developer delivers **image + config**; operations runs it—with less script debugging on the server.

## References

- [Docker overview](https://docs.docker.com/get-started/docker-overview/)
- Aligns with introductory course material before running your first container.
