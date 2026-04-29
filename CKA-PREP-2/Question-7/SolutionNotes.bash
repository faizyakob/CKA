#!/bin/bash
# ============================================================
# Solution Notes - Question 7: Pod Disruption Budget
# ============================================================
#
# STEP 1: Create the PodDisruptionBudget
#   cat <<EOF | kubectl apply -f -
#   apiVersion: policy/v1
#   kind: PodDisruptionBudget
#   metadata:
#     name: critical-pdb
#     namespace: pdb-ns
#   spec:
#     minAvailable: 3
#     selector:
#       matchLabels:
#         app: critical
#   EOF
#
# STEP 2: Verify
#   kubectl get pdb critical-pdb -n pdb-ns
#
#   Output should show:
#   NAME           MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
#   critical-pdb   3               N/A               1                     Xs
#
#   ALLOWED DISRUPTIONS = current replicas - minAvailable = 4 - 3 = 1
#
# STEP 3: Observe PDB during a drain (dry-run, safe)
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#   kubectl drain $WORKER --ignore-daemonsets --dry-run
#
# BONUS: You can also use maxUnavailable instead of minAvailable:
#   maxUnavailable: 1  (same effect as minAvailable: 3 when replicas=4)
#
# EXAM TIP: PDBs only affect VOLUNTARY disruptions (drains, evictions).
# They do NOT protect against node failures or OOM kills.
# ============================================================
