import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://localhost:3000';

export const options = {
  stages: [
    { duration: '10s', target: 2 },
    { duration: '15s', target: 5 },
    { duration: '3m', target: 600 },
  ],
};

export default function () {
  // must be success
  const createRes = http.post(
    `${BASE_URL}/urls`,
    JSON.stringify({ original_url: 'https://quickpizza.grafana.com/' }),
    { headers: { 'Content-Type': 'application/json' } }
  );

  check(createRes, {
    'status is 201': (r) => r.status === 201,
    'has shorted_url': (r) => r.json('shorted_url') !== undefined,
  });

  if (createRes.status === 201) {
    const shorted_url = createRes.json('shorted_url').toString();

    // Request com tag fixa
    const getRes = http.get(shorted_url, {
      redirects: 0,
      tags: { name: 'shorted_redirect' },
    });
    check(getRes, { 'GET status is 302': (r) => r.status === 302 });

    // Cache test também com tag fixa
    const getResCache = http.get(shorted_url, {
      redirects: 0,
      tags: { name: 'shorted_redirect_cache' },
    });
    check(getResCache, { 'GET status is 302': (r) => r.status === 302 });
  }

  // must be fail - já é fixo, não explode cardinalidade
  const getRes = http.get(`${BASE_URL}/1`, {
    redirects: 0,
    tags: { name: 'not_found_url' },
  });
  check(getRes, { 'GET status is 404': (r) => r.status === 404 });

  sleep(1);
}
