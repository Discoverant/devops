# Discoverant / Adroit DI Security Audit (Pre-Launch)

**Date:** 2026-01-15
**Environment:** Single live environment (Option 1)
**Owner:** Discoverant / Adroit DI
**Scope:** Host, network exposure, Nginx reverse proxy, Docker containers, secrets handling, immediate hardening actions
**Audience:** Internal engineering and external partners/auditors

---

## Executive summary

This audit documents the current security posture of the pre-launch Discoverant deployment and the immediate hardening actions taken to reduce attack surface without changing architecture or availability. The environment is intentionally pre-launch and may be unauthenticated, so the priority is to prevent unintended public exposure of stateful services while preserving developer access and operational continuity.

**Key findings**
- Public web access is served only via **Nginx on 80/443** for `app.discoverant.com`.
- The application routes traffic internally:
  - `https://app.discoverant.com/` -> frontend at `127.0.0.1:3100`
  - `https://app.discoverant.com/api/` -> backend at `127.0.0.1:8000`
- Docker publishes several service ports at the host level, which requires **host firewall enforcement** to prevent public access.
- UFW was active but contained **contradictory ALLOW rules** that could override intended DENY rules for sensitive ports.

**Risk posture (pre-launch)**
- Main risk: automated scanning or opportunistic access to open ports.
- Acceptable risk: unauthenticated application access during pre-launch testing, provided infrastructure services are not publicly reachable.

---

## Architecture overview (as-built)

### Host
- Ubuntu 22.04 LTS
- Nginx reverse proxy on host
- Docker used for application and supporting services

### Nginx reverse proxy routing
- HTTP (80) redirects to HTTPS (443)
- HTTPS (443) routes:
  - `/api/` -> `http://127.0.0.1:8000/api/`
  - `/` -> `http://127.0.0.1:3100`

### Containerized services (representative)
- **Backend API** (Python; FastAPI/Flask depending on component) on host port **8000** (should be private)
- **Frontend** on host port **3100** (private; proxied by Nginx)
- **PostgreSQL** on host port **5432** (must be private)
- **Redis** on host port **6379** (must be private)
- **PgBouncer** on host port **6432** (must be private)
- **Elasticsearch (legacy)** on host port **9200** (must be private; disable if unused)

---

## Network exposure

### Intended public exposure
- 80/tcp (HTTP)
- 443/tcp (HTTPS)
- 22/tcp (SSH; temporary pre-launch requirement)

### Intended LAN-only exposure
- 3001/tcp (dev/ops tooling)
- 8081/tcp (dev/ops tooling)

### Intended private (not public)
- 5432/tcp (PostgreSQL)
- 6379/tcp (Redis)
- 6432/tcp (PgBouncer)
- 9200/tcp (Elasticsearch)
- 3000/tcp (dev)
- 8080/tcp (dev)
- 3389/tcp (RDP)

### UFW findings
- UFW is active with default deny inbound.
- Contradictory rules were present (e.g., DENY plus later ALLOW Anywhere), which **negates protection** for sensitive ports.
- IPv6 ALLOW Anywhere rules for sensitive ports present similar risk if not removed.

### Docker + UFW interaction
- Docker publishes ports via `docker-proxy` and iptables rules.
- Host listeners can show as `0.0.0.0:<port>` even when services are intended to be internal.
- **UFW must be authoritative** for restricting inbound access to these ports.

---

## Data stores and internal services

### PostgreSQL
- Must not be reachable from the public internet.
- Access should be limited to:
  - application containers on the Docker network
  - localhost admin access when required
  - LAN-only access only when explicitly needed

### Redis
- Not designed for public exposure; should be restricted to Docker network or localhost.

### PgBouncer
- Connection pooler for PostgreSQL.
- Must be private; public exposure increases brute-force and credential stuffing risk.

### Elasticsearch (legacy)
- If unused, should be removed or unbound from host ports in a later maintenance window.
- If required, enforce strict network isolation and authentication.

---

## Authentication posture (pre-launch)

- The application may be intentionally unauthenticated at this stage to support internal testing and rapid iteration.
- This is acceptable **only if** infrastructure services are not publicly reachable and HTTP access is monitored.
- Optional short-term controls (non-blocking):
  - Nginx basic auth on `/` and/or `/api/`
  - IP allow-list for partners or internal networks

---

## Secrets handling

- Secrets must **not** be committed to Git.
- Expected secret types:
  - Database URLs and credentials
  - API keys
  - Application secret keys (session/JWT)
- Controls:
  - `.env` files excluded from VCS
  - Secret rotation before external launch
  - Avoid default/demo credentials

---

## Known risks and accepted risks

### Known risks
- Docker-published ports create host listeners that must be actively firewalled.
- Pre-launch unauthenticated access could expose application behavior to scanning.
- Legacy Elasticsearch exposure would be high risk if publicly reachable.

### Accepted risks (pre-launch only)
- Public access to the application UI/API without auth for controlled testing.
- SSH (22/tcp) open to the public temporarily for operations.

---

## Hardening actions completed

- UFW rule rationalization to enforce intended public/LAN/private exposure.
- Removal of contradictory ALLOW rules that negated DENY rules for sensitive ports.
- Explicit DENY rules for PostgreSQL, Redis, PgBouncer, Elasticsearch, and common dev ports, including IPv6 where applicable.

---

## Recommended next steps (non-breaking)

**Immediate (today)**
- Validate firewall exposure externally (e.g., from a non-LAN network).
- Confirm IPv6 rules mirror IPv4 intentions.

**Near term**
- Remove unused Elasticsearch container or stop publishing 9200 to host.
- Bind internal services to `127.0.0.1` where host access is needed; otherwise remove host port publishing.

**Pre-beta**
- Add a temporary auth wall (Nginx basic auth or IP allow-list).
- Centralize secrets into managed storage and rotate pre-launch credentials.
- Add rate limiting and request size limits on `/api/`.

---

## Change log

- **2026-01-15:** Rewrote audit, clarified exposure rules, and recorded firewall hardening outcomes for pre-launch.
