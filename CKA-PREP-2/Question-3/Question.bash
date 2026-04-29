#!/bin/bash
# ============================================================
# CKA Practice - Question 3: Jobs & CronJobs
# ============================================================
#
# QUESTION:
# Task:
#   1. Create a Job named "batch-job" in namespace "batch-ns" that:
#        - Uses image: busybox:1.35
#        - Runs: echo "batch complete" && sleep 5
#        - Completes 3 times (completions: 3)
#        - Runs up to 2 Pods in parallel (parallelism: 2)
#
#   2. Create a CronJob named "cron-cleanup" in namespace "batch-ns"
#      that:
#        - Uses image: busybox:1.35
#        - Runs: echo "cleanup done"
#        - Schedule: every 5 minutes  (*/5 * * * *)
#        - Keeps 2 successful job history and 1 failed job history
#
#   3. Verify:
#        kubectl get jobs -n batch-ns
#        kubectl get cronjobs -n batch-ns
#
# TOPIC: Workloads & Scheduling
# DIFFICULTY: Medium
# ============================================================
