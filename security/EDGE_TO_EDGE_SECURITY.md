cd /home/lingard/devops/security

cat > EDGE_TO_EDGE_SECURITY.md <<'EOF'
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
  - Router admin interface is not reachable from the WAN.
- **Separate Guest Wi-Fi**
  - Guest network is isolated from LAN.
  - Guest devices cannot access laptops or servers on the LAN.
- **Strong admin credentials**
  - Non-default, unique, strong password.
- **Firmware**
  - Router firmware kept up to date.
- **UPnP**
  - Disabled (or tightly restricted) to prevent accidental port exposure.
- **WPS**
  - Disabled.

### Threats mitigated
- Internet-based router takeover via exposed admin UI
- Lateral movement from guest/IoT to trusted LAN
- Accidental port exposure via UPnP
- Weak onboarding via WPS

---

## 2. Operator Endpoint (Laptop)

The laptop is part of the trusted admin boundary.

### Controls (recommended / expected)
- Full-disk encryption enabled (FileVault on Mac)
- Strong login password + biometrics
- OS updates enabled
- No “shared” admin accounts
- SSH keys protected; no private keys copied to untrusted devices

### Threats mitigated
- Credential theft leading to server access
- Malware/session hijack leading to spoofed SSH access

---

## 3. Access Path to Server

### Controls in place
- **SSH restricted to LAN**
  - UFW allows TCP/22 only from `192.168.1.0/24`.
- **Tailscale present**
  - Provides a private overlay network (optional for admin access).
- **No public SSH**
  - Nmap from outside shows port 22 filtered.

### Threats mitigated
- Internet brute-force against SSH
- Opportunistic scanning

---

## 4. Server Edge Controls

### Controls in place
- UFW enabled with default deny inbound
- Only 80/443 publicly reachable
- Database/admin ports denied inbound
- Nginx front door for web traffic
- Periodic security audit report generated weekly

---

## 5. Evidence and Auditability

### Weekly audit
- Cron: `/etc/cron.d/security-audit-weekly` (Sun 03:15 UTC)
- Runner: `/usr/local/sbin/run_security_audit.sh`
- Output: timestamped report in `/home/lingard/devops/security/attachments/`
- Hash ledger: `/home/lingard/devops/security/SECURITY_AUDIT_SHA256SUMS.txt`
- Email: full report in the email body to `richard.lingard@adroitdi.com`

---

## 6. Explicit Non-Claims

This setup is **not** presented as:
- ISO 27001 / SOC2 compliant
- A substitute for managed security monitoring/SIEM
- A hardened multi-tenant production environment

It *is* appropriate for:
- Internal-only, pre-customer use
- Small trusted operator set
- Documented, repeatable checks with evidence

---

## 7. Risk Position Statement

Given:
- No external users
- No customer data
- Single trusted operator

This posture is **proportionate, documented, and auditable**.

Further hardening would provide diminishing returns at this stage.
EOF

---

## 8. Router and NAS Final Risk Position (Closed)

### Router status (Hyperoptic EX3301-T0)

The internet edge router configuration has been reviewed and hardened.

**Confirmed controls in place:**
- Remote administration: **DISABLED**
  - Router admin interface is not accessible from the WAN.
- IPv4 and IPv6 firewall: **ENABLED**
- Firewall policy: **Medium (recommended)**
  - LAN → WAN allowed
  - WAN → LAN blocked
- DoS protection: **ENABLED**
- No inbound port forwarding configured
- No exposed management services

**Status:**  
✔ Router security posture is **fixed, documented, and closed**.  
No further router-side hardening is required at this stage.

---

### Home NAS (WD My Cloud Home)

A WD My Cloud Home NAS exists on the same LAN and is used **only for family backups**.

**Important clarifications:**
- NAS does **not** store:
  - Server credentials
  - SSH keys
  - Production data
  - Application secrets
- Backup contents are **not publicly visible**
  - Remote users cannot browse or enumerate backup data
  - Access is mediated via vendor authentication
- NAS is **not used** for server or infrastructure backups

**Risk assessment:**
- Risk level: **LOW**
- NAS is outside the server trust boundary
- Compromise of NAS would **not** provide access to the server
- Independent protections exist:
  - Router firewall
  - Server UFW
  - No trust relationship between NAS and server

**Mitigation status:**
- NAS risk is understood, documented, and accepted
- Future reduction (optional): migrate family users off remote access and restrict NAS to LAN-only

---

### Final statement

The end-to-end security posture (router → laptop → network → server) is now:

- **Documented**
- **Auditable**
- **Proportionate to a pre-customer, internal-only system**

No known high or medium risks remain open.
