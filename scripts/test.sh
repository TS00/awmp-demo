#!/bin/bash
# AWMP Demo: Acceptance test for chaos health endpoint
# Exit 0 = PASS, Exit 1 = FAIL

set -e

PORT=${PORT:-3000}
URL="http://localhost:${PORT}/health"

echo "Testing health endpoint at ${URL}..."

# Wait for server to be ready
for i in {1..5}; do
  if curl -s "${URL}" > /dev/null 2>&1; then
    break
  fi
  echo "Waiting for server... (${i}/5)"
  sleep 1
done

# Make request and capture response
RESPONSE=$(curl -s "${URL}" || echo '{"status": "connection_failed"}')
echo "Response: ${RESPONSE}"

# Check for expected pass criteria
if echo "${RESPONSE}" | grep -q '"status": "ok"'; then
  echo "✓ PASS: Health endpoint returns OK"
  exit 0
else
  echo "✗ FAIL: Health endpoint does not return OK"
  exit 1
fi
