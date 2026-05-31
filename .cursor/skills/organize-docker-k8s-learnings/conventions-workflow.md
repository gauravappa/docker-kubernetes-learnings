# Conventions workflow (shared by organize & polish skills)

## Priority order

When organizing, moving files, or writing notes:

1. **[user-conventions.md](user-conventions.md)** — explicit user rules (highest)
2. **Existing repo layout** — if the tree already differs from defaults, stay consistent with what is on disk
3. **[folder-structure.md](folder-structure.md)** / **[note-template.md](note-template.md)** — repo defaults
4. **SKILL.md** — workflow only; do not treat inline examples as rules if they conflict with the files above

## Detect convention input

Treat the user message (and relevant prior messages in the same thread) as convention input when they:

- Describe where files **should** live ("put all k8s yaml under `k8s/manifests/`")
- Rename or redefine folders, files, or categories
- Specify note structure ("every note needs a Troubleshooting section")
- Specify tone, language, headings, date format, or markdown style
- Say "from now on", "always", "use this structure", "follow this format"
- Paste a template or example and ask to match it

**Not** convention input (do not update this file): one-off paths for a single file ("move this Dockerfile to X"), unless they generalize it ("always put Dockerfiles there").

## Update procedure

Run **before** organizing or polishing when convention input is present. Also run at the start of every invocation to load current rules.

### 1. Parse

Split input into:

| Type | Goes in |
|------|---------|
| Directory tree, categories, naming, `examples/` rules | `user-conventions.md` → **Folder structure** |
| README sections, voice, code block rules, tables | `user-conventions.md` → **Writing format** |

### 2. Write `user-conventions.md`

- Add bullet rules under the right section (replace the placeholder line when first rule is added).
- Merge with existing bullets; do not duplicate.
- If a new rule contradicts an old one, **replace** the old bullet and note the superseded rule in changelog.
- Add a **Changelog** row: `Date` (today), `Section`, one-line summary of what the user asked for.

### 3. Sync defaults (when the rule is permanent)

Keep `user-conventions.md` as the source of truth. Also patch defaults so future readers see one coherent story:

| User rule type | Also update |
|----------------|-------------|
| Changes top-level tree, categories, topic layout, naming | [folder-structure.md](folder-structure.md) — edit matching section; add a line: `> User override: see user-conventions.md` only if partial override |
| Changes note sections, style, template | [note-template.md](note-template.md) — align template and style rules |

Do **not** edit `SKILL.md` for routine layout/format preferences.

### 4. Confirm to user

After updating conventions, briefly list:

- New or changed rules (bullets)
- Which files were updated (`user-conventions.md`, and any synced file)

Then continue with organize or polish using the updated rules.

## Examples

**User:** "Use `LEARNINGS.md` instead of `README.md` in each topic folder."

- **Folder structure:** `- Topic note filename: LEARNINGS.md (not README.md)'`
- **Sync:** `folder-structure.md` topic folder diagram + organize skill Step 5 references → agent uses LEARNINGS.md when implementing (organize SKILL may still say README until synced — sync note-template paths in folder-structure)

**User:** "Add a 'Gotchas' section to every note."

- **Writing format:** `- Required section: ## Gotchas (after Observations, before Takeaways)'`
- **Sync:** `note-template.md` add section to template

**User:** "@organize-docker-k8s-learnings files are in root — also always date-stamp lab folders as `labs/YYYY-MM-DD-slug`"

- Update conventions first, then run organize workflow.

## Revoke or reset

- **Revoke one rule:** User names the rule → remove bullet, changelog entry "Removed: …"
- **Reset all custom rules:** Only if user explicitly asks to reset conventions → clear sections (restore placeholders), changelog note "Reset to defaults", revert synced sections in folder-structure.md / note-template.md to match shipped defaults
