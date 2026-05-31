---
name: polish-docker-k8s-note
description: >-
  Polishes a Docker or Kubernetes learning note using user-conventions.md,
  synced private .ref course clones, and course-notes PDF for accuracy. Use for
  format-only requests, note polish, or note style preferences without reorganizing.
disable-model-invocation: true
---

# Polish Docker & Kubernetes Note

Improve readability of **one** learning note without running the full organize workflow.

## When to use

- User points to a specific `README.md` (or draft note) to clean up
- Wording is rough but files are already in the right place
- User says "polish note", "format this README", "make this readable"

For uncommitted files scattered in the repo, use **organize-docker-k8s-learnings** instead.

## Step 0: Load and update conventions (always first)

Same as organize skill — read [user-conventions.md](../organize-docker-k8s-learnings/user-conventions.md) first. If the user defines or changes **writing format** (or folder rules that affect note paths), follow [conventions-workflow.md](../organize-docker-k8s-learnings/conventions-workflow.md) before polishing.

## Step 0b: Private reference sources (`.ref/`)

Before polishing, run [ref-sources-workflow.md](../organize-docker-k8s-learnings/ref-sources-workflow.md): sync clones, refresh `ref-index.md` if needed, read index then relevant exercises **and matching PDF course-notes sections** (or grep `pdf-notes-extract.txt`). Do not expose `.ref` paths or remotes in the polished note.

## Steps

1. Read the target note and any `examples/` it references (same directory).
2. Apply [user-conventions.md](../organize-docker-k8s-learnings/user-conventions.md) **Writing format**, then [note-template.md](../organize-docker-k8s-learnings/note-template.md).
3. Preserve all technical facts, commands, paths, and versions from the original.
4. Improve grammar, headings, tables, and code fences; add missing **Overview**, **Takeaways**, or **Examples in this folder** table if absent.
5. Add relative links to example files; do not move or rename files unless the user asks.
6. Show a brief summary: what improved in the note; if conventions were updated, list new rules and files touched.

## Convention-only requests

If the user only specifies format ("always add a Quiz section") with no target file, update conventions per [conventions-workflow.md](../organize-docker-k8s-learnings/conventions-workflow.md) and confirm — do not invent a note to polish.

## Do not

- Invent commands or outcomes the user did not document
- Commit changes unless asked
- Expand into generic tutorials

## Cross-reference

Full repo layout and move rules: [organize-docker-k8s-learnings](../organize-docker-k8s-learnings/SKILL.md).
