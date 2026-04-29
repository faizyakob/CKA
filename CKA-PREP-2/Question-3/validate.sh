#!/bin/bash
# ============================================================
# Validate - Question 3: Jobs & CronJobs
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 3"
echo "======================================"

check "Job 'batch-job' exists in batch-ns" \
  "kubectl get job batch-job -n batch-ns"

check "batch-job completions is 3" \
  "kubectl get job batch-job -n batch-ns -o jsonpath='{.spec.completions}' | grep -q 3"

check "batch-job parallelism is 2" \
  "kubectl get job batch-job -n batch-ns -o jsonpath='{.spec.parallelism}' | grep -q 2"

check "batch-job has completed at least 1 time" \
  "[ \$(kubectl get job batch-job -n batch-ns -o jsonpath='{.status.succeeded}') -ge 1 ]"

check "CronJob 'cron-cleanup' exists in batch-ns" \
  "kubectl get cronjob cron-cleanup -n batch-ns"

check "cron-cleanup schedule is */5 * * * *" \
  "kubectl get cronjob cron-cleanup -n batch-ns -o jsonpath='{.spec.schedule}' | grep -q '\*/5 \* \* \* \*'"

check "cron-cleanup successfulJobsHistoryLimit is 2" \
  "kubectl get cronjob cron-cleanup -n batch-ns -o jsonpath='{.spec.successfulJobsHistoryLimit}' | grep -q 2"

check "cron-cleanup failedJobsHistoryLimit is 1" \
  "kubectl get cronjob cron-cleanup -n batch-ns -o jsonpath='{.spec.failedJobsHistoryLimit}' | grep -q 1"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
