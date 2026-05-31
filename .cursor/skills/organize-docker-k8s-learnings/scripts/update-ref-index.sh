#!/usr/bin/env bash
# Regenerates .ref/ref-index.md from local course clones (no network).
# Run from learning-repo root after syncing .ref repos.

set -euo pipefail

ROOT="${1:-.}"
REF="$ROOT/.ref"
OUT="$REF/ref-index.md"
GENERATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
PDF_EXTRACT_NOTE=""

if [[ ! -d "$REF" ]]; then
  echo "Missing $REF — create .ref with course clones first." >&2
  exit 1
fi

repo_meta() {
  local dir="$1"
  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" rev-parse HEAD 2>/dev/null || echo "unknown"
  else
    echo "not-a-git-repo"
  fi
}

list_exercise_modules() {
  local base="$1"
  local label="$2"
  if [[ ! -d "$base/_exercises" ]]; then
    return
  fi
  echo "### $label — \`_exercises\` modules"
  echo ""
  echo "| Module | Lessons | Sample topics (from filenames) |"
  echo "|--------|---------|--------------------------------|"
  for mod in "$base/_exercises"/*; do
    [[ -d "$mod" ]] || continue
    name="$(basename "$mod")"
    count="$(find "$mod" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
    topics="$(find "$mod" -maxdepth 1 -name '*.md' 2>/dev/null \
      | while IFS= read -r f; do basename "$f"; done \
      | sed 's/^[0-9]*-//;s/.md$//' | tr '-' ' ' | head -5 \
      | awk 'BEGIN{ORS=", "}{print} END{print ""}' | sed 's/, $//')"
    [[ -z "$topics" ]] && topics="—"
    echo "| \`$name\` | $count | $topics |"
  done
  echo ""
}

list_sample_dirs() {
  local base="$1"
  local label="$2"
  echo "### $label — sample / demo directories (repo root)"
  echo ""
  echo "| Directory | Likely use |"
  echo "|-----------|------------|"
  while IFS= read -r d; do
    base_name="$(basename "$d")"
    case "$base_name" in
      _exercises|_slides|.git) continue ;;
    esac
    [[ -d "$d" ]] || continue
    hint="supporting code"
    [[ -f "$d/Dockerfile" || -f "$d/compose.yaml" || -f "$d/docker-compose.yml" ]] && hint="Dockerfile / compose"
    [[ -f "$d/package.json" ]] && hint="Node app + containerize"
    echo "| \`$base_name\` | $hint |"
  done < <(find "$base" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort)
  echo ""
}

pdf_section() {
  echo "## Course notes (PDF)"
  echo ""
  echo "The PDF is **lecture/course notes** (not just diagrams). Use it together with exercise markdown for the same topic."
  echo ""
  local pdfs
  pdfs="$(find "$REF" -name '*.pdf' -type f 2>/dev/null | sort)"
  if [[ -z "$pdfs" ]]; then
    echo "*(no PDF found under .ref)*"
    echo ""
    return
  fi
  echo "| Path (under .ref) | Size | Role |"
  echo "|-------------------|------|------|"
  while IFS= read -r p; do
    rel="${p#"$REF"/}"
    size="$(du -h "$p" | cut -f1)"
    echo "| \`$rel\` | $size | Course notes — read topic-relevant sections |"
  done <<< "$pdfs"
  echo ""
  echo "**Lookup:** After picking a module from the tables below, open the PDF and read/search only the section that matches that module (e.g. volumes, Deployments). Do not read the entire PDF each run."
  echo ""
  if [[ -n "$PDF_EXTRACT_NOTE" ]]; then
    echo "$PDF_EXTRACT_NOTE"
    echo ""
  else
    echo "*(Optional: install \`pdftotext\` to auto-generate \`.ref/pdf-notes-extract.txt\` for faster search on next index run.)*"
    echo ""
  fi
}

maybe_extract_pdf_notes() {
  command -v pdftotext >/dev/null 2>&1 || return 0
  local primary
  primary="$(find "$REF" -maxdepth 2 -name '*.pdf' -type f 2>/dev/null | head -1)"
  [[ -n "$primary" ]] || return 0
  pdftotext "$primary" "$REF/pdf-notes-extract.txt" 2>/dev/null || return 0
  local lines
  lines="$(wc -l < "$REF/pdf-notes-extract.txt" | tr -d ' ')"
  PDF_EXTRACT_NOTE="**Searchable extract:** \`.ref/pdf-notes-extract.txt\` ($lines lines) — grep for topic keywords before opening the PDF."
}

DOCKER="$REF/docker-course"
K8S="$REF/kubernetes-course"

maybe_extract_pdf_notes

{
  echo "# Reference index (local memory)"
  echo ""
  echo "> **Private** — lives in gitignored \`.ref/\`. Regenerate after course repo updates."
  echo "> **Do not** commit this file to the learning repo."
  echo ""
  echo "| Field | Value |"
  echo "|-------|-------|"
  echo "| Generated (UTC) | $GENERATED_AT |"
  if [[ -d "$DOCKER" ]]; then
    echo "| docker-course commit | \`$(repo_meta "$DOCKER")\` |"
  fi
  if [[ -d "$K8S" ]]; then
    echo "| kubernetes-course commit | \`$(repo_meta "$K8S")\` |"
  fi
  echo ""
  echo "## How agents use this file"
  echo ""
  echo "1. **Read this index first** to map a learning note topic → exercise module or sample dir."
  echo "2. Open **only** the 1–3 listed exercise \`.md\` files or sample paths for that topic."
  echo "3. For the same topic, read **relevant sections** of the course-notes PDF (or \`pdf-notes-extract.txt\` if present) — do not read the whole PDF."
  echo "4. After \`git pull\` changes HEAD in a course repo, re-run:"
  echo "   \`bash .cursor/skills/organize-docker-k8s-learnings/scripts/update-ref-index.sh\`"
  echo ""
  echo "## Topic → learning repo folders (hints)"
  echo ""
  echo "| You are writing about… | Suggested folder in learning repo | Primary ref |"
  echo "|------------------------|-----------------------------------|-------------|"
  echo "| First container, docker run, CLI | \`docker/fundamentals/\` | docker-course \`01-running_containers\` |"
  echo "| Images, build, Hub, Dockerfile basics | \`docker/dockerfile/\`, \`docker/images/\` | \`03-introduction_images\`, \`05-images_deep_dive\` |"
  echo "| Express / React containerize projects | \`docker/dockerfile/\` or \`labs/\` | \`04-containerize_express_app\`, \`06-containerize_react_app\` |"
  echo "| Volumes, bind mounts | \`docker/storage/\` | \`07-volumes\`, compose \`03-bind_mounts\` |"
  echo "| CPU, memory, networks, restart | \`docker/networking/\`, \`docker/fundamentals/\` | \`08-advanced_topics\` |"
  echo "| Docker Compose | \`docker/compose/\` | \`10-docker_compose\`, \`compose/\` dir |"
  echo "| Multi-app compose (notes, key-value) | \`labs/\` or \`docker/compose/\` | \`11-notes_app\`, \`09-key_value_app\` |"
  echo "| Pods, kubectl basics | \`kubernetes/fundamentals/\` | k8s \`01-running_containers_k8s\` |"
  echo "| YAML, imperative vs declarative | \`kubernetes/fundamentals/\`, \`kubernetes/config/\` | \`02-object_management_yaml_manifests\` |"
  echo "| ReplicaSet, Deployment, rollouts | \`kubernetes/workloads/\` | \`03-replicasets_deployments\` |"
  echo "| Services (ClusterIP, NodePort, etc.) | \`kubernetes/networking/\` | \`04-services\`, \`services/\` dir |"
  echo "| Labels, namespaces, quotas, probes | \`kubernetes/scheduling/\`, \`kubernetes/workloads/\` | \`05-resource_management\`, \`health-probes/\` |"
  echo "| PV, PVC, StatefulSet, storage | \`kubernetes/storage/\` | \`06-storage_persistence\`, \`stateful-sets/\` |"
  echo "| ConfigMap, Secret | \`kubernetes/config/\` | \`07-configuration_management\`, \`config-maps/\`, \`secrets/\` |"
  echo "| MongoDB project | \`labs/\` or \`kubernetes/storage/\` | \`08-deploy_mongodb_database\`, \`proj-mongodb/\` |"
  echo "| RBAC, NetworkPolicy, PSS | \`kubernetes/security/\` | \`09-security_fundamentals\`, \`rbac/\`, \`network-policies/\` |"
  echo "| Kustomize | \`kubernetes/config/\` or dedicated topic | \`10-kustomize\`, \`kustomize/\` |"
  echo "| GKE deploy project | \`labs/\` | \`11-deploy_color_api_gke\`, \`proj-gke/\` |"
  echo ""
  pdf_section

  if [[ -d "$DOCKER" ]]; then
    echo "## docker-course"
    echo ""
    list_exercise_modules "$DOCKER" "Docker course"
    list_sample_dirs "$DOCKER" "Docker course"
    echo "<details>"
    echo "<summary>All docker exercise files (paths relative to docker-course)</summary>"
    echo ""
    echo "\`\`\`"
    find "$DOCKER/_exercises" -name '*.md' 2>/dev/null | sed "s|^$DOCKER/||" | sort
    echo "\`\`\`"
    echo "</details>"
    echo ""
  fi

  if [[ -d "$K8S" ]]; then
    echo "## kubernetes-course"
    echo ""
    list_exercise_modules "$K8S" "Kubernetes course"
    list_sample_dirs "$K8S" "Kubernetes course"
    echo "<details>"
    echo "<summary>All kubernetes exercise files (paths relative to kubernetes-course)</summary>"
    echo ""
    echo "\`\`\`"
    find "$K8S/_exercises" -name '*.md' 2>/dev/null | sed "s|^$K8S/||" | sort
    echo "\`\`\`"
    echo "</details>"
    echo ""
  fi
} > "$OUT"

echo "Wrote $OUT"
