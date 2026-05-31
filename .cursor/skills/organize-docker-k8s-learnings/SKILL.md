---
name: organize-docker-k8s-learnings
description: >-
  Organizes Docker and Kubernetes learning artifacts in this repo: scans
  uncommitted changes, moves files into the folder layout, writes or polishes
  notes, and persists user folder/format preferences into user-conventions.md.
  Use when organizing learnings, specifying repo layout or note format, or
  arranging uncommitted Docker/Kubernetes work.
disable-model-invocation: true
---

# Organize Docker & Kubernetes Learnings

Turn messy experiments and scratch files into a readable, browsable learning repo.

## When to run

Invoke explicitly after a learning session when you have new or edited files (Dockerfiles, compose files, manifests, shell history snippets, draft notes).

Also invoke when the user only wants to **set or change** folder structure or note format for future runs — update conventions first, then organize if needed.

## Step 0: Load and update conventions (always first)

1. Read [user-conventions.md](user-conventions.md), then [folder-structure.md](folder-structure.md) and [note-template.md](note-template.md).
2. If the user message (or same-thread context) specifies **folder structure** or **writing format**, follow [conventions-workflow.md](conventions-workflow.md): update `user-conventions.md`, sync `folder-structure.md` / `note-template.md` when appropriate, tell the user what was saved.
3. Apply all rules from **user-conventions** when planning paths and writing notes (override defaults).

## Workflow (follow in order)

Copy this checklist and mark items as you go:

```
- [ ] 0. Load / update user conventions
- [ ] 1. Inventory uncommitted changes
- [ ] 2. Classify each artifact
- [ ] 3. Plan target paths (no duplicates)
- [ ] 4. Move/rename files and create folders
- [ ] 5. Write or improve topic notes
- [ ] 6. Update root README index if needed
- [ ] 7. Summarize for the user (do not commit unless asked)
```

### Step 1: Inventory uncommitted changes

Run in parallel:

```bash
git status --short
git diff
git diff --cached
```

Also list untracked files. Read every changed/new file that looks like learning content (skip `.git`, `.cursor`, editor junk, secrets).

**Never** stage, move, or rewrite `.env`, credentials, kubeconfig with secrets, or private keys. Warn the user if those appear in changes.

### Step 2: Classify each artifact

For each file, decide:

| Question | Options |
|----------|---------|
| Domain | `docker` or `kubernetes` (or `general` for cross-cutting cheatsheets) |
| Topic | [user-conventions.md](user-conventions.md) + [folder-structure.md](folder-structure.md) |
| Type | `config` (Dockerfile, compose, yaml), `script`, `note`, `lab` (multi-file experiment) |
| Status | `keep` (production-quality example), `draft` (works but rough), `scratch` (merge into notes then delete if redundant) |

If one session produced several related files, prefer a **lab folder** (dated slug) under `labs/` instead of scattering files.

### Step 3: Plan target paths

Rules:

- One **topic** = one folder with the topic note file + `examples/` (configs and scripts). Default note filename is `README.md` unless **user-conventions** says otherwise.
- File names: lowercase, hyphen-separated (`deployment-replicas.yaml`, not `test.yaml`).
- Do not leave configs in repo root except `README.md`.
- If a topic folder already exists, **extend** its README; do not create `notes2.md` or duplicate topics.
- Before moving, check for name collisions; rename with a short descriptive suffix if needed.

Full layout: conventions + [folder-structure.md](folder-structure.md).

### Step 4: Move files and create folders

- Create missing directories from the standard layout.
- Use `git mv` when files are already tracked; otherwise move and ensure paths are correct.
- Keep relative links in notes valid after moves.
- Remove empty scratch directories left behind.

### Step 5: Write or improve notes

Each topic folder's primary note (default `README.md`) is the learning doc. Use [user-conventions.md](user-conventions.md) **Writing format** + [note-template.md](note-template.md).

**Improve existing notes** — preserve facts and commands; do not invent steps the user did not run:

- Match the user's required sections and voice from **Writing format**; if none, use template defaults
- Clear H1 title matching the topic
- Short overview (what this is, why it matters)
- Fix grammar; default voice is neutral ("run", "create") unless conventions specify otherwise
- Default heading flow: Goal → Prerequisites → Steps → Examples → Takeaways → References (extend per conventions)
- Put commands in fenced `bash` blocks; configs in fenced blocks with language tag (`dockerfile`, `yaml`)
- Link to example files with relative paths: `[examples/Dockerfile](examples/Dockerfile)`
- Add a **Date** line near the top when the session date is known (from git or user context)
- End with **Takeaways** (3–5 bullets) and optional **References** (official docs links)

**New notes** — synthesize from file contents and diffs: what was tried, commands used, purpose of each config file.

Do not add filler ("Docker is a platform..."). Assume future-you remembers basics; focus on what *you* did and learned.

### Step 6: Root README index

If new topics were added, add a row to the index table in the repo root `README.md`:

```markdown
## Index

| Topic | Path | Summary |
|-------|------|---------|
| Multi-stage builds | [docker/images/multi-stage](docker/images/multi-stage) | Build smaller images with builder pattern |
```

Keep summaries to one line.

### Step 7: Report to user

Reply with:

1. **What changed** — table of old path → new path
2. **Notes updated** — which README files were created or rewritten
3. **Open questions** — anything ambiguous (topic choice, whether to delete scratch files)
4. **Suggested commit message** — only if they might commit; do not commit unless they ask

## Quality bar

- Notes should be skimmable in under 2 minutes: headings, bullets, code blocks.
- Every example file in `examples/` should be mentioned in the topic README (what it demonstrates).
- YAML and Dockerfiles: keep minimal comments in configs; explain behavior in README.
- Prefer one concept per topic folder; split if a README exceeds ~150 lines.

## Additional resources

- [user-conventions.md](user-conventions.md) — your overrides (updated when you specify layout or format)
- [conventions-workflow.md](conventions-workflow.md) — how to detect, save, and sync preferences
- [folder-structure.md](folder-structure.md) — default directory tree and naming rules
- [note-template.md](note-template.md) — default template for topic notes
