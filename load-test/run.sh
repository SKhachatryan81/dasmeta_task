#!/usr/bin/env bash
# Stepped load test: runs podinfo.js at increasing concurrency levels and prints one row per level.
# Usage:  ./load-test/run.sh                       (URL taken from the reserved static IP)
#         BASE_URL=http://... STEPS="1 10 50" DURATION=60 ./load-test/run.sh
set -euo pipefail
cd "$(dirname "$0")"

if [ -z "${BASE_URL:-}" ]; then
  ip=$(gcloud compute addresses describe nginx-ingress-ip --region europe-west1 \
         --project dasmeta-task --format='value(address)')
  BASE_URL="http://podinfo.${ip}.sslip.io"
fi
STEPS="${STEPS:-1 5 10 25 50 100 200}"
DURATION="${DURATION:-30}"          # seconds per step
PAUSE="${PAUSE:-10}"                # cool-down between steps
OUT="results/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"

SAMPLE=true
kubectl get --raw /readyz --request-timeout=5s >/dev/null 2>&1 || { SAMPLE=false; echo "kubectl unreachable: skipping pod CPU/memory sampling"; }

echo "target: $BASE_URL | steps: $STEPS | ${DURATION}s each | results: load-test/$OUT"
printf '%-6s %-9s %-8s %-8s %-8s %-8s %-8s %-8s %-7s\n' VUs requests RPS avg_ms p50_ms p95_ms p99_ms max_ms err%
echo "vus,requests,rps,avg_ms,p50_ms,p95_ms,p99_ms,max_ms,error_rate" > "$OUT/results.csv"

for vus in $STEPS; do
  # sample pod CPU/memory near the end of each step (needs kubectl access; skipped if unavailable)
  if $SAMPLE; then
    ( sleep $((DURATION - 8))
      k="kubectl --request-timeout=5s"
      { echo "## dev"; $k top pods -n dev --no-headers
        echo "## ingress-nginx"; $k top pods -n ingress-nginx --no-headers
        echo "## nodes"; $k top nodes --no-headers; } > "$OUT/top-${vus}.txt" 2>&1 || true ) &
  fi

  k6 run --quiet --no-color -e BASE_URL="$BASE_URL" -e VUS="$vus" -e DURATION="${DURATION}s" \
     -e SUMMARY_FILE="$OUT/summary-${vus}.json" podinfo.js > "$OUT/k6-${vus}.log" 2>&1 || true
  wait

  jq -r --arg v "$vus" '.metrics as $m | [
      $v, $m.http_reqs.values.count, ($m.http_reqs.values.rate*10|round/10),
      ($m.http_req_duration.values.avg|round), ($m.http_req_duration.values.med|round),
      ($m.http_req_duration.values["p(95)"]|round), ($m.http_req_duration.values["p(99)"]|round),
      ($m.http_req_duration.values.max|round), ($m.http_req_failed.values.rate*10000|round/100)
    ] | @csv' "$OUT/summary-${vus}.json" | tr -d '"' | tee -a "$OUT/results.csv" \
    | awk -F, '{printf "%-6s %-9s %-8s %-8s %-8s %-8s %-8s %-8s %-7s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}'

  sleep "$PAUSE"
done
echo "done -> load-test/$OUT/results.csv"
