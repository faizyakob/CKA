# CKA-PREP — Practice Questions 1–17

A set of 17 hands-on practice questions for the **Certified Kubernetes Administrator (CKA)** exam.
Each question mirrors real exam scenarios and includes a lab setup script, solution notes, and an automated validation script.

---

## Recommended Environment

Use **[Killercoda CKA Playground](https://killercoda.com/playgrounds/scenario/kubernetes)** — it provides a pre-built 2-node cluster (1 control-plane + 1 worker) with kubeadm, kubectl, and a Calico CNI, exactly matching the CKA exam environment.

---

## Repository Structure

```
CKA-PREP/
└── Question-N/
    ├── Question.bash      # The question / task description
    ├── LabSetUp.bash      # Sets up the lab environment (run this first)
    ├── SolutionNotes.bash # Step-by-step solution walkthrough
    └── validate.sh        # Automated checks to verify your answer
```

---

## How to Use

For each question:

```bash
# 1. Read the question
cat Question-N/Question.bash

# 2. Set up the lab environment
bash Question-N/LabSetUp.bash

# 3. Attempt the question yourself!

# 4. When done, validate your answer
bash Question-N/validate.sh

# 5. If stuck, consult the solution notes
cat Question-N/SolutionNotes.bash
```

---

## Questions Overview

| # | Topic | Description | Difficulty |
|---|-------|-------------|------------|
| 1 | Workloads & Scheduling | Create a Pod with resources, labels, env vars | Easy |
| 2 | Cluster Architecture | Create a static Pod via kubelet manifests | Easy |
| 3 | Workloads & Scheduling | Scale and update a Deployment with rollout history | Easy |
| 4 | Services & Networking | Create ClusterIP and NodePort Services | Easy/Medium |
| 5 | Configuration | Use ConfigMaps and Secrets as environment variables | Medium |
| 6 | Configuration | Create ResourceQuotas and LimitRanges | Medium |
| 7 | Workloads & Scheduling | Apply Taints, Tolerations, and Node Affinity | Medium |
| 8 | Storage | Create PV, PVC, and mount into a Pod | Medium |
| 9 | Services & Networking | Create a NetworkPolicy to restrict ingress traffic | Medium |
| 10 | Security | Configure RBAC with ServiceAccount, Role, RoleBinding | Medium |
| 11 | Workloads & Scheduling | Create a DaemonSet with a hostPath volume | Medium |
| 12 | Services & Networking | Create a path-based Ingress resource | Medium |
| 13 | Cluster Maintenance | Cordon, Drain, and Uncordon a worker node | Easy |
| 14 | Storage / Architecture | Backup and restore etcd | Hard |
| 15 | Cluster Upgrades | Upgrade the cluster with kubeadm | Hard |
| 16 | Troubleshooting | Fix a broken kube-scheduler | Hard |
| 17 | Networking / Config | Restrict nginx to TLSv1.3 only | Hard |

---

## CKA Exam Domain Weights (2024)

| Domain | Weight |
|--------|--------|
| Cluster Architecture, Installation & Configuration | 25% |
| Workloads & Scheduling | 15% |
| Services & Networking | 20% |
| Storage | 10% |
| Troubleshooting | 30% |

---

## Tips for the Real Exam

- **Use imperative commands first** — `kubectl run`, `kubectl create`, `kubectl expose` are faster than writing YAML from scratch.
- **Use `--dry-run=client -o yaml`** to generate base manifests you can then edit.
- **Bookmark the Kubernetes docs** — you are allowed to use https://kubernetes.io/docs during the exam.
- **Verify every task** — always run a `kubectl get` or `kubectl describe` after each action.
- **Use aliases**:
  ```bash
  alias k=kubectl
  export do="--dry-run=client -o yaml"
  ```
- **Set your context** before each question — the exam gives you a `kubectl config use-context` command per question.

---

## Good luck on your CKA! 🚀
