# CKA-PREP2 — Practice Questions 1–17

Second set of 17 hands-on CKA practice questions. Each question covers a
distinct topic from the CKA exam domains with a lab setup, solution notes,
and automated validation.

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
| 1 | Workloads | Init containers with shared emptyDir volume | Medium |
| 2 | Workloads | Multi-container Pod with sidecar log shipper | Medium |
| 3 | Workloads | Jobs with completions/parallelism + CronJobs | Medium |
| 4 | Workloads | Rolling update with a bad image + rollback | Easy |
| 5 | Configuration | ConfigMap mounted as a volume (nginx HTML) | Medium |
| 6 | Workloads / Storage | StatefulSet with headless Service + PVC templates | Hard |
| 7 | Workloads | PodDisruptionBudget with minAvailable | Medium |
| 8 | Security | Secret as volume + ServiceAccount token disabled | Medium |
| 9 | Security | ClusterRole + ClusterRoleBinding for node access | Medium |
| 10 | Workloads | HorizontalPodAutoscaler with CPU target | Medium |
| 11 | Troubleshooting | Fix a Pod with 3 injected bugs | Hard |
| 12 | Storage | Dynamic provisioning with default StorageClass | Medium |
| 13 | Troubleshooting | Fix a Service with a mismatched label selector | Hard |
| 14 | Security | Create, approve, and retrieve a CSR for a user | Hard |
| 15 | Workloads | Node labels + nodeSelector for pod placement | Easy |
| 16 | Troubleshooting | Restore a NotReady node (stopped kubelet) | Hard |
| 17 | Networking | NetworkPolicy with egress control + DNS allowance | Hard |

---

## New Topics vs CKA-PREP1

CKA-PREP2 introduces topics not covered in the first set:

| New Topic | Question |
|-----------|----------|
| Init Containers | Q1 |
| Sidecar / Multi-container Pods | Q2 |
| Jobs & CronJobs | Q3 |
| Rollback with rollout undo | Q4 |
| ConfigMap as volume | Q5 |
| StatefulSet | Q6 |
| PodDisruptionBudget | Q7 |
| Secret as volume + automount disabled | Q8 |
| ClusterRole + ClusterRoleBinding | Q9 |
| HorizontalPodAutoscaler | Q10 |
| Multi-bug Pod troubleshooting | Q11 |
| Dynamic StorageClass provisioning | Q12 |
| Service endpoint troubleshooting | Q13 |
| CertificateSigningRequest | Q14 |
| Node labels + nodeSelector | Q15 |
| kubelet troubleshooting | Q16 |
| Egress NetworkPolicy | Q17 |

---

## Exam Aliases (set these at the start of every session)

```bash
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Example usage:
k run nginx --image=nginx $do > pod.yaml
k delete pod nginx $now
```

---

## Good luck! 🚀
