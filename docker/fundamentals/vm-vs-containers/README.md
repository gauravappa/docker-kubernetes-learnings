# VMs vs containers

**Date:** 2026-05-31  
**Status:** draft

## Overview

Virtual machines (VMs) and containers both isolate workloads, but they do it at different layers. VMs ship a full guest OS; containers share the host kernel and package only the app and its dependencies. That difference drives weight, portability, and startup time.

See also: [Why containers?](../why-containers/README.md) — motivation before this comparison.

## Goal

Clarify what a VM is, how it differs from a container, and why containers are lighter and faster to start for typical app deployment.

## Prerequisites

- None (conceptual). Complements [why-containers](../why-containers/README.md).

## Virtual machines (VMs)

A **virtual machine** is a full computer simulated in software:

- Each VM runs its own **guest operating system** (Linux, Windows, etc.).
- A **hypervisor** sits between VMs and the **host OS**, mediating CPU, memory, storage, and network access.
- The guest OS boots like a physical machine: kernel, services, and components all initialize on start.

Because every VM carries a full OS, VMs are **heavy** (more disk and RAM) and **slower to start** (full boot cycle).

| Aspect | VM behavior |
|--------|-------------|
| Isolation | Strong — separate kernel per VM |
| Size | Large (whole OS + app) |
| Portability | Tied to hypervisor and VM image format; moving workloads can be more involved |
| Startup | Slower — guest OS must boot |

## Containers

A **container** runs a process in an isolated view of the host, using a **container runtime** (e.g. Docker):

- The container includes the **application** and **dependencies** it needs (libraries, binaries, config)—not a separate guest OS.
- It uses the **host kernel** through the runtime; no second OS to boot inside the container.
- Any machine that has a compatible **container runtime** can run the same image.

Containers are **lightweight** (smaller images, less overhead) and **faster to start** (start the app process, not an entire OS).

| Aspect | Container behavior |
|--------|-------------------|
| Isolation | Process/filesystem/network isolation via runtime + kernel features |
| Size | Smaller — app + deps only |
| Portability | High — ship an image; host needs only the runtime |
| Startup | Faster — no guest OS boot |

## Side-by-side

| | VM | Container |
|---|-----|-----------|
| **OS** | Full guest OS per VM | Shares host kernel |
| **Mediator** | Hypervisor | Container runtime |
| **What you ship** | VM disk image | Container image |
| **Typical weight** | Heavy | Light |
| **Typical boot** | Slow (OS init) | Fast (app start) |
| **Host requirement** | Hypervisor | Container runtime |

## Examples in this folder

| File | Purpose |
|------|---------|
| *(none)* | Conceptual notes only |

## Takeaways

- A VM includes a full OS and talks to the host through a **hypervisor**; that makes it strong but heavy and slow to boot.
- A container bundles **app + dependencies** and uses the **host kernel** via a **container runtime**.
- Containers are more **portable** in practice: the destination host only needs a runtime, not a matching hypervisor stack for a guest OS.
- **Startup time** favors containers because there is no guest OS to initialize.
- VMs still matter when you need a different OS or kernel-level isolation; containers fit most single-OS app deployment.

## References

- [Docker overview](https://docs.docker.com/get-started/docker-overview/)
- Aligns with introductory course material on containers vs traditional virtualization.
