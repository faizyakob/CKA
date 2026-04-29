#!/bin/bash
# ============================================================
# Solution Notes - Question 3: Jobs & CronJobs
# ============================================================
#
# STEP 1: Create the Job
#   cat <<EOF | kubectl apply -f -
#   apiVersion: batch/v1
#   kind: Job
#   metadata:
#     name: batch-job
#     namespace: batch-ns
#   spec:
#     completions: 3
#     parallelism: 2
#     template:
#       spec:
#         restartPolicy: Never
#         containers:
#         - name: batch
#           image: busybox:1.35
#           command: ["sh", "-c", "echo 'batch complete' && sleep 5"]
#   EOF
#
# STEP 2: Create the CronJob
#   cat <<EOF | kubectl apply -f -
#   apiVersion: batch/v1
#   kind: CronJob
#   metadata:
#     name: cron-cleanup
#     namespace: batch-ns
#   spec:
#     schedule: "*/5 * * * *"
#     successfulJobsHistoryLimit: 2
#     failedJobsHistoryLimit: 1
#     jobTemplate:
#       spec:
#         template:
#           spec:
#             restartPolicy: Never
#             containers:
#             - name: cleanup
#               image: busybox:1.35
#               command: ["sh", "-c", "echo 'cleanup done'"]
#   EOF
#
# STEP 3: Verify
#   kubectl get jobs -n batch-ns
#   kubectl get cronjobs -n batch-ns
#   kubectl get pods -n batch-ns   # watch Job pods complete
#
# EXAM TIP: Jobs require restartPolicy: Never or OnFailure.
# Never = create a new Pod on failure. OnFailure = restart same Pod.
# CronJobs do NOT run immediately — wait for the schedule or use:
#   kubectl create job --from=cronjob/cron-cleanup manual-run -n batch-ns
# ============================================================
