# CKA-PREP-3 — Practice Questions 1–17

Third set of 17 hands-on CKA practice questions. Each question targets
a distinct scenario drawn from real CKA exam domains, with full lab setup,
solution walkthrough, and automated validation.

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
| 1 | Workloads | Liveness, Readiness & Startup Probes | Medium |
| 2 | Configuration | Namespace quota + LimitRange default injection | Medium |
| 3 | Workloads | PriorityClass & Pod preemption | Medium |
| 4 | Workloads | ReplicaSet direct management & self-healing | Easy |
| 5 | Security | SecurityContext — runAsUser, readOnly fs, drop caps | Medium |
| 6 | Troubleshooting | OOMKilled Pod diagnosis & fix | Medium |
| 7 | Networking | Ingress with TLS termination (self-signed cert) | Hard |
| 8 | Storage | PV Reclaim Policy (Retain) & manual PV release | Hard |
| 9 | Cluster Arch | kubeconfig merging & context/namespace management | Medium |
| 10 | Troubleshooting | Broken kube-apiserver (bad etcd endpoint) | Hard |
| 11 | Workloads | Topology Spread Constraints for even Pod distribution | Hard |
| 12 | Networking | Default-deny NetworkPolicy + selective allow | Hard |
| 13 | Troubleshooting | Broken CoreDNS (bad upstream forwarder) | Hard |
| 14 | Workloads | Pod Affinity + Pod Anti-Affinity rules | Hard |
| 15 | Security | Full user onboarding: CSR + RBAC + kubeconfig | Hard |
| 16 | Cluster Arch | Worker node only upgrade with drain/uncordon | Hard |
| 17 | Security | ServiceAccount API access from inside a Pod | Hard |

---

## New Topics vs CKA-PREP1 & CKA-PREP2

| New Topic | Question |
|-----------|----------|
| Startup + Liveness + Readiness Probes | Q1 |
| LimitRange default injection enforcement | Q2 |
| PriorityClass & Pod preemption | Q3 |
| ReplicaSet (direct, without Deployment) | Q4 |
| SecurityContext (runAsUser, readOnlyFS, capabilities) | Q5 |
| OOMKilled diagnosis (Exit Code 137) | Q6 |
| Ingress with TLS termination | Q7 |
| PV Retain policy & manual PV release | Q8 |
| kubeconfig merging & context management | Q9 |
| kube-apiserver troubleshooting (crictl) | Q10 |
| Topology Spread Constraints | Q11 |
| Default-deny NetworkPolicy pattern | Q12 |
| CoreDNS troubleshooting | Q13 |
| Pod Affinity & Anti-Affinity | Q14 |
| Full user onboarding workflow | Q15 |
| Worker-node-only upgrade | Q16 |
| ServiceAccount in-cluster API calls | Q17 |

---

## Questions Requiring a Fresh Session

The following questions modify cluster components — always run them
on a **fresh Killercoda session** to avoid side effects:

| Question | What it breaks |
|----------|---------------|
| Q10 | kube-apiserver (bad etcd endpoint) |
| Q13 | CoreDNS (bad upstream forwarder) |
| Q16 | Worker node upgrade (version change) |

---

## Exam Day Checklist

```bash
# Set these at the start of every session:
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Switch context per question (given at top of each exam question):
kubectl config use-context <context-name>

# Verify current context before every task:
kubectl config current-context
kubectl get nodes
```

---

## Good luck! 🚀
