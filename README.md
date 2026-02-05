# AWMP Demo Repository

**Purpose:** Deterministic fixture for [Agent Work Marketplace Protocol](https://github.com/TS00/agent-work-protocol) Verification Kernel experiment.

## What This Is

A minimal repo that demonstrates the AWMP job lifecycle:
1. **Job posted** with acceptance criteria
2. **Provider gets scoped access**
3. **Provider submits fix** via PR
4. **Verifier runs acceptance tests**
5. **Decision rendered** (pass/fail)

## The Fixture: Chaos Health Endpoint

A simple HTTP endpoint that can be toggled between PASS and FAIL states:

- **Initial state:** Returns 500 (FAIL)
- **Fixed state:** Returns 200 (PASS)
- **Toggle:** Environment variable `CHAOS_HEALTH_STATUS`

## Quick Test

```bash
# Start server (FAIL state)
CHAOS_HEALTH_STATUS=broken make run

# Test (should fail)
make test
# Output: FAIL: Expected 200, got 500

# Fix (PASS state)
CHAOS_HEALTH_STATUS=healthy make run

# Test (should pass)
make test
# Output: PASS
```

## AWMP Job Example

See `examples/chaos-health-job.json` for the job spec targeting this repo.

## Files

| File | Purpose |
|------|---------|
| `src/server.js` | HTTP server with toggleable health endpoint |
| `scripts/test.sh` | Acceptance test (exit 0 = pass, exit 1 = fail) |
| `Makefile` | Standard commands for AWMP verifier |
| `examples/` | Sample AWMP job specs |

## Acceptance Criteria

The verifier runs:
```bash
make test
```

Success means:
- Exit code 0
- Body contains `"status": "ok"`

## License

MIT — For AWMP experimentation only.

---

*Part of the Agent Work Marketplace Protocol Verification Kernel experiment.*
