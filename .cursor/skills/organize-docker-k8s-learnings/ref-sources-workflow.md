# Reference sources workflow (`.ref/`)

Private, **gitignored** course material lives under `.ref/` at the learning-repo root. Never commit `.ref/`, never document remote URLs in skills or in published notes.

Both **organize** and **polish** skills run this workflow when writing or updating notes.

## Step A: Discover (from learning-repo root)

```bash
test -d .ref && echo "ref-present" || echo "ref-missing"
```

If `.ref` is missing, skip Steps B–E; tell the user notes will not be cross-checked against course refs.

### Local memory index (read first)

```bash
test -f .ref/ref-index.md && echo "index-present"
```

**`.ref/ref-index.md`** is the course map: module list, topic → folder hints, git commit SHAs, PDF location. **Always read it before** searching repos or opening the PDF.

- If missing → run **Step B2** (regenerate index) after clones are present.
- If present → use it to pick 1–3 exercise files or sample dirs; do **not** full-repo grep or read the **entire** PDF each run.

### Course notes (PDF)

The PDF under `.ref` (e.g. `docker_k8s_slides.pdf`) contains **course/lecture notes** — explanations, concepts, and commands — not just slides or diagrams.

| File | Use |
|------|-----|
| `.ref/ref-index.md` | Which PDF path(s) exist; map topic → module first |
| `.ref/pdf-notes-extract.txt` | Plain-text extract (if generated); **grep** for topic keywords before opening PDF |
| PDF itself | Read **topic-relevant sections/pages** only, aligned with the matched `_exercises` module |

### Git course clones

```bash
find .ref -maxdepth 2 -type d -name .git 2>/dev/null | while read g; do dirname "$g"; done
```

Typical layout: `.ref/docker-course/`, `.ref/kubernetes-course/` — always use discovered paths.

## Step B: Sync each discovered clone (every invocation)

Record HEAD **before** pull for each repo:

```bash
REPO="<discovered-path>"
BEFORE="$(git -C "$REPO" rev-parse HEAD 2>/dev/null)"
git -C "$REPO" fetch origin
BRANCH="$(git -C "$REPO" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"
git -C "$REPO" checkout "$BRANCH" 2>/dev/null || git -C "$REPO" checkout main 2>/dev/null || git -C "$REPO" checkout master
git -C "$REPO" pull --ff-only origin "$BRANCH"
AFTER="$(git -C "$REPO" rev-parse HEAD 2>/dev/null)"
```

- Request **network** for `fetch` / `pull`.
- On failure: report briefly, continue with local tree.
- **Do not** push or commit inside course repos unless the user asks.

## Step B2: Refresh `.ref/ref-index.md` when needed

Regenerate if **any** of:

- `ref-index.md` does not exist
- `BEFORE != AFTER` for any course repo after pull
- Index commit SHAs ≠ current `git rev-parse HEAD` in docker-course or kubernetes-course
- User asks to refresh the index

From learning-repo root:

```bash
bash .cursor/skills/organize-docker-k8s-learnings/scripts/update-ref-index.sh
```

This rescans `_exercises` modules, sample directories, PDF metadata, and rewrites `.ref/ref-index.md`. If `pdftotext` is installed, also creates `.ref/pdf-notes-extract.txt` for searchable course notes.

## Step C: Map topic → references (index-first)

| Step | Action |
|------|--------|
| 1 | Read `.ref/ref-index.md` — module tables + topic → folder hints |
| 2 | Open matching `_exercises/<module>/*.md` (1–3 files) |
| 3 | **Course notes:** grep `.ref/pdf-notes-extract.txt` for topic keywords, or read the matching section of the PDF (same module/title as the exercise) |
| 4 | Open sample dirs from index only if exercises reference them |

| Note domain | Index section |
|-------------|----------------|
| Docker | `docker-course` |
| Kubernetes | `kubernetes-course` |

**Reference trio for a topic:** exercise markdown + PDF notes section + (optional) sample code in course repo.

## Step D: Use references when writing notes

- **Accuracy**: Align commands and concepts with exercise steps **and** PDF course notes unless the user's experiment differed — then document both.
- **Attribution**: Optional "Aligns with course notes on …" — **no** remote URLs, **no** `.ref/` paths in committed learning notes.
- **Synthesis**: Notes reflect what the user ran; course material verifies and fills gaps.
- **Examples**: Prefer the user's `examples/`; course snippets only when needed.

## Do not

- Add `.ref/` paths or git remote URLs to committed notes or `user-conventions.md`
- Stage or commit anything under `.ref/`
- Scan entire course repos or read the **full** PDF when index + targeted sections suffice

## Checklist (for organize / polish)

```
- [ ] A. .ref exists?
- [ ] B. Each clone: fetch + pull; note if HEAD changed
- [ ] B2. Regenerate ref-index.md (and pdf-notes-extract.txt if pdftotext available)
- [ ] C. Read ref-index → exercises + PDF notes section (or grep extract)
- [ ] D. Note written or polished
```
