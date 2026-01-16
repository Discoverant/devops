# Weekly Security Audit – Architecture (1 page)

## Goal
Run a repeatable security audit on the Dell (Ubuntu) server, store a tamper-evident report, and email the full report to Richard on each run.

## What happens every run
1) `/usr/local/sbin/run_security_audit.sh` runs as root (cron).
2) It generates a timestamped Markdown report:
   - `/home/lingard/devops/security/attachments/SECURITY_AUDIT_<UTC>.md`
3) It computes a SHA-256 hash and appends it to the ledger:
   - `/home/lingard/devops/security/SECURITY_AUDIT_SHA256SUMS.txt`
4) It updates the rolling “latest” files:
   - `/home/lingard/devops/security/SECURITY_AUDIT.md`
   - `/home/lingard/adroit-chemistry-rebuild/SECURITY_AUDIT.md`
5) It emails Richard with the **full report in the email body** (no attachment dependency).

## Scheduling
Cron:
- `/etc/cron.d/security-audit-weekly`
- Runs: Sunday 03:15 (server time / UTC)
- Command:
  - `/usr/local/sbin/run_security_audit.sh >> /var/log/security_audit.log 2>&1`

## Mail setup notes
- Postfix is forced to IPv4 (`inet_protocols = ipv4`) to avoid reverse-DNS issues on IPv6.
- Canonical mapping is a hash map (`canonical_maps = hash:/etc/postfix/canonical`) so root mail rewrites to Richard.

## Logs and retention
- Audit log: `/var/log/security_audit.log`
- Logrotate: `/etc/logrotate.d/security_audit` (weekly, rotate 12, compressed)

## Quick manual run
Run and verify:
- `sudo /usr/local/sbin/run_security_audit.sh`
- `sudo tail -n 50 /var/log/security_audit.log`
- `sudo tail -n 200 /var/log/mail.log | grep status=sent | tail`
