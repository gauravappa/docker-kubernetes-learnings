# VMs vs containers

**Date:** 2026-05-31  
**Status:** draft

## Overview

VMs and containers both run isolated workloads, but at **different layers**. A VM emulates hardware and boots a **full guest OS**; a container runs an **app process** on the **host kernel** through a runtime. That split explains why containers are usually lighter and faster to start.

After reading this page you should understand:

- What a hypervisor does for VMs
- Why each VM is “heavy” and slower to boot
- How containers share the host kernel and stay portable
- When a VM is still the better choice

See also: [Why containers?](../why-containers/README.md) — deployment motivation before this comparison.

## Goal

Define **VM vs container**, compare weight, portability, and startup time, and connect the comparison to what you will run next on the CLI.

## Prerequisites

- None (conceptual). Complements [why-containers](../why-containers/README.md).

## Virtual machines (VMs)

A **virtual machine** behaves like a separate computer:

```
Host OS
  └── Hypervisor
        ├── VM A (guest OS + app)
        └── VM B (guest OS + app)
```

- Each VM runs its own **guest operating system** (Linux, Windows, etc.).
- A **hypervisor** sits between VMs and the **host OS**, mediating CPU, memory, storage, and network.
- On start, the **guest OS boots** fully—kernel, services, and components—like a physical machine.

Because every VM carries a full OS, VMs are **heavy** (disk, RAM) and **slower to start** (full boot cycle). Portability can also depend on **hypervisor software** and VM image format.

| Aspect | VM behavior |
|--------|-------------|
| Isolation | Strong — separate kernel per VM |
| Size | Large (whole OS + app) |
| Portability | Tied to hypervisor and VM image format |
| Startup | Slower — guest OS must boot |

## Containers

A **container** is an isolated process (or tree of processes) on the host, managed by a **container runtime** (e.g. Docker):

```
Host OS (single kernel)
  └── Container runtime
        ├── Container A (app + deps)
        └── Container B (app + deps)
```

- The image holds the **application** and **dependencies** (libraries, binaries, config)—not a guest OS.
- Workloads use the **host kernel** through the runtime; nothing boots a second OS inside the container.
- Any host with a compatible **container runtime** can run the same image.

Containers are **lightweight** and **fast to start** because you start the app, not an entire operating system.

| Aspect | Container behavior |
|--------|-------------------|
| Isolation | Process, filesystem, and network isolation via runtime + kernel |
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

## When to use which

| Choose a **VM** when… | Choose a **container** when… |
|------------------------|------------------------------|
| You need a **different OS** than the host (e.g. Windows on Linux) | You deploy **apps on a shared Linux host** (typical cloud/native pattern) |
| You want **hard kernel isolation** between tenants | You want **fast deploy, scale, and density** on one kernel |
| You lift-and-shift whole legacy machines | You package **app + deps** as an image |

For day-to-day Docker learning, containers are the default; VMs remain important for full-OS isolation and mixed-OS estates.

**Next in this repo:** [Container lifecycle](../container-lifecycle/README.md) — states and CLI after you understand what a container is.

## Examples in this folder

| File | Purpose |
|------|---------|
| *(none)* | Conceptual notes only |

## Observations

- “Portable” for containers means **image + runtime**, not re-installing a guest OS on every host.
- Container isolation is strong for apps but **not** the same as separate kernels—that is why VMs still exist.
- Hypervisor choice (Type 1 vs Type 2) affects VM portability; container portability is more about **runtime and image architecture** (e.g. `linux/amd64`).

## Takeaways

- A VM includes a full OS; a **hypervisor** connects it to the host—strong isolation, but heavy and slow to boot.
- A container bundles **app + dependencies** and uses the **host kernel** through a **container runtime**.
- Containers start faster because there is **no guest OS** to initialize.
- Destination hosts need only a **runtime** for containers, not a full hypervisor stack per workload.
- Use VMs for different OS or kernel-level separation; use containers for most app deployment on Docker/Kubernetes paths.

## References

- [Docker overview](https://docs.docker.com/get-started/docker-overview/)
- Aligns with introductory course material on containers vs traditional virtualization.
