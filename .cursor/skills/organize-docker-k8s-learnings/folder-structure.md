# Repository folder structure

**Read [user-conventions.md](user-conventions.md) first.** User rules there override this file. When the user specifies a new layout while a skill is active, update `user-conventions.md` (and this file if the change is permanent) per [conventions-workflow.md](conventions-workflow.md).

Defaults below apply when no user override exists. If the repo on disk already differs, prefer consistency with existing folders.

## Top level

```
docker-kubernetes-learnings/
├── README.md                 # Repo intro + index table of topics
├── docker/                   # Docker-only learnings
├── kubernetes/               # Kubernetes-only learnings
├── labs/                     # Multi-file experiments (optional)
└── cheatsheets/              # Short reference sheets (optional)
```

## Topic folder (standard unit)

Each learning topic is a directory with a note and examples:

```
docker/<category>/<topic-slug>/
├── README.md                 # Learning note (required)
└── examples/                 # Configs, scripts, sample apps
    ├── Dockerfile
    ├── docker-compose.yaml
    └── ...
```

```
kubernetes/<category>/<topic-slug>/
├── README.md
└── examples/
    ├── deployment.yaml
    └── service.yaml
```

### Docker categories

| Category | Use for |
|----------|---------|
| `fundamentals` | Images, containers, run/exec/logs, basics |
| `dockerfile` | Dockerfile instructions, build context, .dockerignore |
| `images` | Tagging, registries, multi-stage, size optimization |
| `networking` | bridge/host/none, ports, DNS, links |
| `storage` | volumes, bind mounts, tmpfs |
| `compose` | docker-compose / Compose spec |
| `security` | users, capabilities, secrets (non-k8s) |
| `ci-cd` | BuildKit, bake, pipeline patterns |

### Kubernetes categories

| Category | Use for |
|----------|---------|
| `fundamentals` | kubectl, contexts, namespaces, API basics |
| `workloads` | Pod, Deployment, StatefulSet, Job, CronJob |
| `networking` | Service, Ingress, NetworkPolicy, DNS |
| `storage` | PV, PVC, StorageClass, config patterns |
| `config` | ConfigMap, Secret, downward API |
| `scheduling` | Requests/limits, affinity, taints, HPA |
| `security` | RBAC, SA, Pod Security, policies |
| `observability` | probes, logs, metrics (learning scope) |

Create a new category folder only when no existing category fits.

## Labs (multi-file sessions)

When a session has many files or a mini-app:

```
labs/<YYYY-MM-DD>-<short-slug>/
├── README.md                 # Session narrative (same quality as topic README)
├── docker/ or kubernetes/  # Optional: mirror structure if mixed
└── ...                     # App source, configs, etc.
```

After the lab stabilizes, you may **promote** reusable pieces into `docker/...` or `kubernetes/...` topic folders and leave the lab README pointing to the promoted paths.

## Cheatsheets

Short, command-focused references only:

```
cheatsheets/docker-cli.md
cheatsheets/kubectl.md
```

No `examples/` subfolder unless a one-liner config is essential.

## Naming rules

| Item | Rule | Example |
|------|------|---------|
| Topic slug | lowercase, hyphens | `volume-bind-mount` |
| Config files | descriptive | `nginx-deployment.yaml` |
| Avoid | `test`, `tmp`, `new`, `copy`, `final2` | — |
| Dates in labs | ISO `YYYY-MM-DD` | `2026-05-31-nginx-compose` |

## Classifying ambiguous files

| File | Destination |
|------|-------------|
| `Dockerfile` | `docker/<category>/<topic>/examples/` |
| `docker-compose*.yml` | `docker/compose/<topic>/examples/` |
| `*.yaml` with `kind: Deployment` etc. | `kubernetes/<category>/<topic>/examples/` |
| Shell script used in demo | `examples/` next to related configs |
| Long prose only | Topic `README.md` (not a separate `notes.md`) |
| Mixed docker + k8s in one session | `labs/<date>-<slug>/` |

## Index maintenance

Root `README.md` should contain an **Index** table linking to every topic and lab README under `docker/`, `kubernetes/`, and `labs/`.
