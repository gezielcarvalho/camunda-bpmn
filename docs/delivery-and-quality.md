# Delivery and quality

## Current delivery posture

The repository is a learning/staging lab. Its documentation, health checks, sample workflow, and container assets provide a repeatable starting point but do not establish production readiness.

## Validation boundary

- Use the documented health-check script and tutorials to verify a local environment.
- The Vue modeler has build and lint scripts; this documentation-only change does not assert a current build/test run.
- Sample/default credentials are development conveniences only and must not be reused outside a controlled local environment.

## Production prerequisites

1. Replace and rotate all defaults; inject secrets through an approved secrets-management system.
2. Enable and configure identity/SSO, TLS, hostnames, and least-privilege access.
3. Design persistence, backups, recovery, scaling, monitoring, logs, and incident operations for the desired workload.
4. Add workflow workers, automated tests, CI, and release evidence for each real process.
5. Review Camunda licensing, version compatibility, and platform support before organizational use.

## Documentation-only validation

Validate Markdown links and whitespace/diff checks. No Compose, environment, credential, or runtime changes are included.
