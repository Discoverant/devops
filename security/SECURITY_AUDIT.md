# Discoverant Security Audit (Pre-Launch)

**Date:** 2026-01-15  
**Environment:** Single live environment (“Option 1”)  
**Owner:** Discoverant / Adroit DI  
**Scope:** Host + network exposure + reverse proxy + containers + secrets + immediate hardening actions

---

## 1. Executive summary

This document records the current security posture of the Discoverant pre-launch deployment and the immediate hardening actions taken to reduce attack surface while preserving development velocity.

**Key findings**
- Public web access is served via **Nginx on 80/443** for `app.discoverant.com`.
- The application currently routes:
  - `https://app.discoverant.com/` → frontend at `127.0.0.1:3100`
  - `https://app.discoverant.com/api/` → backend at `127.0.0.1:8000`
- Multiple infrastructure services are present (PostgreSQL, Redis, PgBouncer, Elasticsearch). Prior to remediation, some ports were unintentionally permitted by firewall rules due to contradictory UFW entries (ALLOW after DENY).
- A firewall policy is in place (UFW active) and is being tightened to ensure only intended public endpoints are reachable.

**Risk posture**
- Pre-launch, private discovery risk is not the main concern; automated scanning of open ports is.
- The priority is **network isolation of stateful services** and removal of unnecessary public listeners.

---

## 2. Architecture overview (as-built)

### 2.1 Host
- Ubuntu 22.04 LTS
- Nginx reverse proxy on host
- Docker used for application and supporting services

### 2.2 Reverse proxy routing
Nginx vhost `app.discoverant.com`:

- HTTP (80) redirects to HTTPS
- HTTPS (443) routes:
  - `/api/` → `http://127.0.0.1:8000/api/`
  - `/` → `http://127.0.0.1:3100`

This design ensures the backend is intended to be reachable only through the reverse proxy (not directly from the public internet).

### 2.3 Containers observed running (representative)
- **Backend API** (Python; FastAPI/Flask depending on component) exposed at host port **8000** (should be private)
- **Frontend** (React dev server or static site) exposed at host port **3100** (private; proxied by Nginx)
- **PostgreSQL** exposed at host port **5432** (must be private)
- **Redis** exposed at host port **6379** (must be private)
- **PgBouncer** exposed at host port **6432** (should be private)
- **Elasticsearch** exposed at host port **9200** (legacy; if unused, should not be public)

---

## 3. Network exposure audit

### 3.1 Observed listeners (host level)
Host listeners were observed on:
- 80/tcp (Nginx)
- 443/tcp (Nginx)
- 8000/tcp (backend)
- 3100/tcp or other frontend port (frontend)
- 5432/tcp (PostgreSQL)
- 6379/tcp (Redis)
- 6432/tcp (PgBouncer)
- 9200/tcp (Elasticsearch)

Note: Docker publishing causes `docker-proxy` to listen on `0.0.0.0:<port>` even when the service is intended for internal use. This is acceptable only when host firewall rules restrict access.

### 3.2 Firewall state (UFW)
UFW is active with default deny inbound; however, several contradictory rules existed (e.g., `DENY 5432` combined with `ALLOW 5432/tcp Anywhere`), which negated the intended protection.

**Immediate objective**
- Allow only: 80/443 (public), 22 (admin), and any explicitly LAN-only dev ports.
- Deny: 5432/6379/9200/6432 and other nonessential public listeners.

### 3.3 IPv6 considerations
UFW rules apply separately to IPv6. Any “ALLOW Anywhere (v6)” rules for sensitive ports must be removed, and explicit denies should exist where appropriate.

---

## 4. Data security

### 4.1 PostgreSQL
- Must never be directly reachable from the public internet.
- Access should be limited to:
  - backend containers (Docker network)
  - localhost administration (optional)
  - LAN-only (optional; if required)

### 4.2 PgBouncer
- Purpose: connection pooling (transaction pooling) to improve resilience under load.
- PgBouncer should be accessible only inside Docker network(s) or from localhost/LAN if explicitly required.
- Public exposure increases brute-force risk and should be blocked at the firewall.

### 4.3 Redis
- Used for caching/queues/sessions depending on service configuration.
- Redis is not designed to be exposed publicly.
- Must be restricted to Docker network / localhost only.

### 4.4 Elasticsearch (legacy)
- If not actively used, it should be stopped and not published on a host port.
- If used, it must be protected by network isolation and authentication controls.

---

## 5. Application security

### 5.1 External surface
- Public: `https://app.discoverant.com` (Nginx only)
- Intended: backend access via `/api/` through Nginx proxy

### 5.2 Authentication posture (pre-launch)
At this stage, the site may be intentionally unauthenticated for internal testing. This is an accepted risk only if:
- infrastructure ports are not publicly reachable
- logs are monitored
- quick “auth wall” can be applied when needed

Recommended short-term control (optional):
- Nginx basic auth for all routes or for `/api/` only, as a temporary barrier.

---

## 6. Secrets & configuration

### 6.1 Environment variables
Secrets should not be committed to GitHub. Items to validate:
- Database URLs and credentials
- Any API keys
- Secret keys used for sessions/JWTs

### 6.2 Hard-coded credentials (risk)
Any instances of default or demo credentials (e.g., `changeme123`, placeholder secret keys) must be replaced before any external user access.

---

## 7. Hardening actions completed / in progress

### 7.1 Firewall rule rationalisation (in progress)
- Remove contradictory UFW rules that allow public access to sensitive ports.
- Deny PgBouncer (6432/tcp) publicly.
- Remove public allowances for dev ports unless explicitly required.

### 7.2 Recommended next hardening steps
**Immediate (today)**
- Ensure only 80/443 and admin SSH are publicly reachable.
- Confirm external port closure from outside the LAN (mobile tether test).

**Near term**
- Remove unused Elasticsearch container or stop publishing port 9200.
- Bind internal services to `127.0.0.1` where host access is required; otherwise remove host port publishing entirely.

**Pre-beta**
- Add temporary Nginx basic auth (simple “password wall”) or restrict by IP allow-list.
- Centralise secrets into `.env` files excluded from git / secret manager.
- Add rate limiting to `/api/` endpoints and tighten request size limits if needed.

---

## 8. Evidence / artefacts

### 8.1 Nginx vhost
- `~/nginx-app.discoverant.com.conf` routes `/api/` to `127.0.0.1:8000` and `/` to `127.0.0.1:3100`.

### 8.2 UFW audit
- UFW active with default deny inbound.
- Numbered rules showed contradictory ALLOW entries for sensitive ports and public exposure of several nonessential ports (e.g., 3000/8080/3389).

---

## 9. Change log

- **2026-01-15:** Began firewall rationalisation to enforce Option 1 (single environment) security posture. Document created to track decisions and actions.
