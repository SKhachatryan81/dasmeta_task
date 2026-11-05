// Basic load test for podinfo through the public nginx ingress.
// One run = a fixed number of virtual users (VUS) hammering GET / for DURATION.
// run.sh calls this once per concurrency level and collects the JSON summaries.
import http from 'k6/http';
import { check } from 'k6';

const BASE_URL = __ENV.BASE_URL;
if (!BASE_URL) throw new Error('BASE_URL is required, e.g. http://podinfo.<ip>.sslip.io');

export const options = {
  vus: Number(__ENV.VUS || 10),
  duration: __ENV.DURATION || '30s',
  summaryTrendStats: ['avg', 'min', 'med', 'p(90)', 'p(95)', 'p(99)', 'max'],
  // "healthy" definition used in the report: <1% errors and p95 under 500ms
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
};

export default function () {
  // no sleep: each VU sends the next request as soon as the previous one returns,
  // so VUs == concurrent in-flight requests
  const res = http.get(`${BASE_URL}/`, { timeout: '10s' });
  check(res, { 'status is 200': (r) => r.status === 200 });
}

export function handleSummary(data) {
  const file = __ENV.SUMMARY_FILE || 'summary.json';
  return { [file]: JSON.stringify(data, null, 2) };
}
