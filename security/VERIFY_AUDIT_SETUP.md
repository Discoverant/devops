# Verify Weekly Security Audit Setup (Operator Runbook)

This document is a non-sudo verifier that **prints the commands** an operator can run with sudo to validate the weekly security audit end-to-end.

## Run the audit now (and write /var/log/security_audit.log)

```bash
sudo /usr/local/sbin/run_security_audit.sh >> /var/log/security_audit.log 2>&1
```

## Check cron service + next run

```bash
# Confirm cron daemon is active
sudo systemctl status cron --no-pager -l

# Show the cron entry
sudo cat /etc/cron.d/security-audit-weekly

# Show next scheduled run time (requires systemd)
systemctl list-timers --all | rg -i 'cron|security|audit'
```

## Check mail delivery (postfix log)

```bash
# Look for status=sent lines from postfix
sudo rg -n "status=sent" /var/log/mail.log | tail -n 20

# Show recent postfix-related lines
sudo rg -n "postfix|postfix/smtp|postfix/qmgr" /var/log/mail.log | tail -n 50
```

## Check postfix configuration

```bash
# IPv4-only setting
sudo postconf inet_protocols

# Relayhost (if configured)
sudo postconf relayhost
```

## Confirm the two audit docs updated

```bash
# Check timestamps
ls -l /home/lingard/devops/security/SECURITY_AUDIT.md
ls -l /home/lingard/adroit-chemistry-rebuild/SECURITY_AUDIT.md

# Show the most recent block tail for each
TAIL_LINES=30

printf "\n--- devops audit tail ---\n"
tail -n "$TAIL_LINES" /home/lingard/devops/security/SECURITY_AUDIT.md

printf "\n--- app audit tail ---\n"
tail -n "$TAIL_LINES" /home/lingard/adroit-chemistry-rebuild/SECURITY_AUDIT.md
```
