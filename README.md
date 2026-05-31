# Docker & Kubernetes Learnings

Personal notes, configs, and experiments while learning Docker and Kubernetes.

## Index

| Topic | Path | Summary |
|-------|------|---------|
| *(add rows as you organize topics)* | | |

## Layout

- `docker/<category>/<topic>/` — Docker notes (`README.md`) + `examples/`
- `kubernetes/<category>/<topic>/` — Kubernetes notes + `examples/`
- `labs/<date>-<slug>/` — Multi-file practice sessions

- Defaults: [folder-structure.md](.cursor/skills/organize-docker-k8s-learnings/folder-structure.md), [note-template.md](.cursor/skills/organize-docker-k8s-learnings/note-template.md)
- **Your overrides** (updated by skills when you specify layout or format): [user-conventions.md](.cursor/skills/organize-docker-k8s-learnings/user-conventions.md)

## Cursor skills

After experimenting, ask the agent to run a skill by name:

| Skill | Use when |
|-------|----------|
| **organize-docker-k8s-learnings** | File uncommitted work, document it, and/or set folder layout rules |
| **polish-docker-k8s-note** | Polish one note and/or set writing-format rules |

Both skills **save** folder and format preferences you state in chat into `user-conventions.md` for future runs.

Example prompts:

- `@organize-docker-k8s-learnings organize my uncommitted learnings`
- `@organize-docker-k8s-learnings lab folders must be labs/YYYY-MM-DD-<slug> — then organize`
- `@polish-docker-k8s-note every note needs a Gotchas section; apply to this README`
