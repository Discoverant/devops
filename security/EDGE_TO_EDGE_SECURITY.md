# Edge-to-Edge Security Summary

## Scope
This document describes the end-to-end security posture for the Discoverant development server and operator workstation.
It covers **router → laptop → network → server**.
This is appropriate for a **pre-customer, internal-only system**.

---

## 1. Network Edge (Router)

The internet edge is treated as the primary trust boundary.

### Controls in place
- **Remote administration: DISABLED**
  - Router admin interface is not reachable from WAN.
- **Separate Guest Wi-Fi**
  - Guest network is isolated from LAN.
  - Guest devices cannot access laptops or servers.
- **Admin credentials**
  - Non-default, strong credentials configured.
- **Firmware**
  - Router firmware kept up to date.

### Threats mitigated
- Internet-based router takeover
- Lateral movement from guest / IoT devices
- Credential reuse against exposed admin interfaces

---

## 2. Operator Endpoint (Laptop)

The operator laptop is treated as a semi-trusted endpoint.

### Controls
- Full-disk encryption enabled (macOS)
- OS updates applied regularly
- No inbound services exposed
- SSH key-based authentication only (no passwords)

### Access model
- Laptop initiates outbound connections only
- No inbound access from internet or guest networks

---

## 3. Network Access Path

### Controls
- Server access restricted by firewall rules (UFW)
- SSH restricted to trusted LAN / VPN ranges
- IPv4-only Postfix configuration (explicit)

---

## 4. Server Security (Ubuntu 22.04)

### Controls
- UFW firewall with default deny (incoming)
- Explicit allow rules only where required
- Docker services firewalled at host level
- Nginx TLS termination on 443
- No public database or cache ports exposed
- SSH restricted to internal network

---

## 5. Continuous Security Audit

A repeatable audit runs **weekly** and can be triggered manually.

### Audit coverage
- OS version and pending security updates
- UFW ruleset
- Listening sockets
- Docker container exposure
- Nginx configuration test
- External nmap spot-check
- Disk usage
- Recent authentication failures

### Evidence handling
- Timestamped Markdown report generated
- SHA-256 hash recorded (tamper-evident)
- Full audit report emailed to operator
- Reports retained locally (not committed to git)

---

## 6. Limitations / Explicit Non-Claims

This setup does **not** claim:
- Zero-trust endpoint enforcement
- SOC monitoring
- IDS/IPS at network edge
- Compliance certification (ISO, SOC2)

Those controls are intentionally deferred until:
- External users exist
- Regulated data is processed
- Commercial deployment begins

---

## 7. Risk Position Statement

Given:
- No external users
- No customer data
- Single trusted operator

This security posture is **proportionate, documented, and auditable**.

Further hardening would provide diminishing returns at this stage.
