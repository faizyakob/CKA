# CKA-PREP-4 — Practice Questions 1–17

Fourth set of 17 hands-on CKA practice questions.

> **All container images in this set support both AMD64 and ARM64 architectures.**
> Images used: `nginx:1.25`, `alpine:3.18`

---

## Recommended Environment

**[Killercoda CKA Playground](https://killercoda.com/playgrounds/scenario/kubernetes)**
— pre-built 2-node cluster matching the real CKA exam environment.

---

## How to Use

```bash
# 1. Read the question
cat Question-N/Question.bash

# 2. Set up the lab
bash Question-N/LabSetUp.bash

# 3. Attempt the question yourself

# 4. Validate your answer
bash Question-N/validate.sh

# 5. Check the solution if needed
cat Question-N/SolutionNotes.bash
```

---

## Questions Overview

| # | Topic | Description | Difficulty |
|---|-------|-------------|------------|
| 1 | Storage / Config | Pod with emptyDir + ConfigMap + Secret volumes | Medium |
| 2 | Workloads | Deployment strategies: Recreate vs RollingUpdate | Medium |
| 3 | Workloads | Downward API — env vars and volume files | Hard |
| 4 | Troubleshooting | Pod stuck Pending due to missing PVC | Medium |
| 5 | Networking | ExternalName Service + Headless Service DNS | Medium |
| 6 | Troubleshooting | CrashLoopBackOff — bad command diagnosis and fix | Easy |
| 7 | Security | Aggregated ClusterRoles with label selectors | Hard |
| 8 | Workloads | hostNetwork + hostPID — host namespace sharing | Medium |
| 9 | Configuration | ConfigMap hot-reload via volume mount | Medium |
| 10 | Networking | NetworkPolicy port-level ingress/egress restriction | Hard |
| 11 | Configuration | Immutable ConfigMaps and Secrets | Easy |
| 12 | Troubleshooting | Broken Ingress — wrong backend service port | Hard |
| 13 | Storage | PVC expansion (resize) with allowVolumeExpansion | Medium |
| 14 | Troubleshooting | Ephemeral containers and kubectl debug | Medium |
| 15 | Workloads | shareProcessNamespace — cross-container visibility | Medium |
| 16 | Troubleshooting | Broken CNI config (pod networking down) | Hard |
| 17 | Networking | Ingress multi-host routing (virtual hosting) | Medium |

---

## New Topics vs CKA-PREP1/2/3

| New Topic | Question |
|-----------|----------|
| Multiple volume types in one Pod | Q1 |
| Recreate vs RollingUpdate strategies | Q2 |
| Downward API (env + volume) | Q3 |
| Pending pod due to missing PVC | Q4 |
| ExternalName + Headless Services | Q5 |
| CrashLoopBackOff root cause analysis | Q6 |
| Aggregated ClusterRoles | Q7 |
| hostNetwork / hostPID | Q8 |
| ConfigMap hot-reload via volume | Q9 |
| Port-level NetworkPolicy | Q10 |
| Immutable ConfigMaps and Secrets | Q11 |
| Ingress backend port troubleshooting | Q12 |
| PVC volume expansion | Q13 |
| kubectl debug / ephemeral containers | Q14 |
| shareProcessNamespace | Q15 |
| CNI config troubleshooting | Q16 |
| Ingress multi-host (virtual hosting) | Q17 |

---

## Questions Requiring a Fresh Session

| Question | What it breaks |
|----------|---------------|
| Q16 | CNI config file (pod networking down) |

---

## Multi-Arch Image Reference

All images in CKA-PREP-4 support **linux/amd64** and **linux/arm64**:

| Image | Source |
|-------|--------|
| `nginx:1.25` | Docker Official |
| `alpine:3.18` | Docker Official |

---

## Exam Day Quick Setup

```bash
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Always run this at the start of each question:
kubectl config use-context <context-name>
kubectl config current-context
```

---

## Good luck! 🚀
