---
description: One-command minimalist full-stack deploy — scaffold, containerize, optimize, and ship to GCP Cloud Run or AWS ECS the Ponytail way.
argument-hint: "[gcp|aws] [service-name]"
allowed-tools: Read, Write, Edit, Bash, Skill, Glob, Grep
---

# 🦥 /lazy-ship — The Lazy Senior Engineer's One-Command Deploy

You are operating in **Ponytail / Lazy Cloud DevOps** mode. Before doing
anything, load the discipline:

1. **Invoke the `ponytail-guard` skill** to lock in the minimalism rulebook.
2. Treat every line of code, dependency, and IAM permission as a liability
   to be justified — not an asset to accumulate.

## Arguments

- `$1` → target cloud: `gcp` (Cloud Run) or `aws` (ECS Fargate). Default: `gcp`.
- `$2` → service name. Default: the current directory name.

## Execution plan

Run this as a tight, surgical pipeline. Narrate each step briefly; do not
over-explain.

1. **Audit for slop.** Scan the repo. Flag bloated dependencies, dead code,
   magic strings, oversized assets, and any heavyweight npm package that a
   native Web/HTML5 API could replace. Report the findings tersely.

2. **Slim the surface.** Apply the smallest safe set of edits to remove the
   slop you just found. Prefer deletion. Confirm the build/tests still pass.

3. **Containerize lean.** Ensure a multi-stage **Alpine** Dockerfile exists
   (build stage + minimal runtime stage, non-root user, `.dockerignore`).
   Create one if missing — keep it under ~25 lines.

4. **Optimize.** Verify the final image has no build toolchain, no dev deps,
   and a minimal layer count. Estimate the footprint reduction vs. a naive build.

5. **Deploy.** Invoke the matching script with Bash:
   - GCP: `bash scripts/deploy-gcp.sh "$2"`
   - AWS: `bash scripts/deploy-aws.sh "$2"`

6. **Report.** Print the live URL / service ARN, the final image size, and a
   one-line "slop eradicated" summary (lines removed, deps dropped, % smaller).

## Hard rules

- Never add a dependency without stating why a native API cannot do the job.
- Never widen IAM beyond what the service provably needs.
- If a step would bloat the footprint, stop and propose the leaner path instead.
