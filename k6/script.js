import http from 'k6/http';
import {check, sleep} from 'k6';

const BASE_URL = 'http://localhost:3000';

export const options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '1m', target: 50 },
    { duration: '30s', target: 0 },
  ]
};

export default function() {
  // must be success
  const createRes = http.post(
    `${BASE_URL}/urls`, JSON.stringify({original_url: "https://quickpizza.grafana.com/" }),
    { headers: { 'Content-Type': 'application/json' },
  });

  check(createRes, {
    'status is 201': (r) => r.status === 201,
    'has shorted_url': (r) => r.json('shorted_url') !== undefined,
  });

  if (createRes.status === 201) {
    const shorted_url = createRes.json('shorted_url').toString();
    const getRes = http.get(shorted_url, { redirects: 0 });
    check(getRes, { 'GET status is 302': (r) => r.status === 302 });
    const getResCache = http.get(shorted_url, { redirects: 0 });
    check(getResCache, { 'GET status is 302': (r) => r.status === 302 });
  }
  // must be fail
  const getRes = http.get(`${BASE_URL}/1`, { redirects: 0 });
  check(getRes, { 'GET status is 404': (r) => r.status === 404 })

  sleep(1);
}
