# AWMP Demo Makefile
# Standard commands for AWMP verifier

.PHONY: install run run-broken run-healthy test fix stop

# Install dependencies
install:
	npm install

# Start server (default: broken state)
run:
	@PORT=${PORT:-3000} node src/server.js

# Start server in BROKEN state (for initial test)
run-broken:
	@CHAOS_HEALTH_STATUS=broken PORT=${PORT:-3000} node src/server.js &
	@echo "Server started in BROKEN state on port ${PORT:-3000}"

# Start server in HEALTHY state (the fix)
run-healthy:
	@CHAOS_HEALTH_STATUS=healthy PORT=${PORT:-3000} node src/server.js &
	@echo "Server started in HEALTHY state on port ${PORT:-3000}"

# Run acceptance test
# This is what the AWMP verifier runs
test:
	@./scripts/test.sh

# Toggle to fixed state (what provider does to fix)
fix:
	@echo "Setting CHAOS_HEALTH_STATUS=healthy"
	@export CHAOS_HEALTH_STATUS=healthy

# Stop running server
stop:
	@-pkill -f "node src/server.js" 2>/dev/null || true
	@echo "Server stopped"

# Full demo cycle (broken → verify fail → fix → verify pass)
demo-broken:
	@echo "=== Step 1: Start broken server ==="
	@make run-broken &
	@sleep 2
	@echo ""
	@echo "=== Step 2: Run acceptance test (should FAIL) ==="
	@make test || echo "Expected failure"
	@make stop

demo-fixed:
	@echo "=== Step 3: Start fixed server ==="
	@make run-healthy &
	@sleep 2
	@echo ""
	@echo "=== Step 4: Run acceptance test (should PASS) ==="
	@make test
	@make stop

.DEFAULT_GOAL := run
