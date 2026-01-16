#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Config
# ----------------------------
DOMAIN="app.discoverant.com"
EMAIL_TO="richard.lingard@adroitdi.com"

AUDIT_DEVOPS="/home/lingard/devops/security/SECURITY_AUDIT.md"
AUDIT_APP="/home/lingard/adroit-chemistry-rebuild/SECURITY_AUDIT.md"

ATT_DIR="/home/lingard/devops/security/attachments"
HASH_LEDGER="/home/lingard/devops/security/SECURITY_AUDIT_SHA256SUMS.txt"

TS="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
TMP_OUT="/tmp/security_audit_${TS}.md"
ATT="${ATT_DIR}/SECURITY_AUDIT_${TS}.md"

mkdir -p "${ATT_DIR}"
touch "${HASH_LEDGER}"

section() { echo ""; echo "### $1"; echo '```'; }
endcode() { echo '```'; echo ""; }

# ----------------------------
# Build audit report
# ----------------------------
{
  echo "# Security Audit Report"
  echo ""
  echo "**Timestamp (UTC):** ${TS}"
  echo "**Host:** $(hostname -f 2>/dev/null || hostname)"
  echo "**Kernel:** $(uname -a)"
  echo ""

  section "External exposure spot-check (nmap key ports)"
  nmap -Pn -p 22,80,443,3000,3001,5432,6379,6432,8080,8081,9200,9201 "${DOMAIN}" || true
  endcode

  section "UFW status"
  ufw status verbose || true
  endcode

  section "Listening sockets (ss -lntp)"
  ss -lntp || true
  endcode

  section "Nginx config test (if installed)"
  if command -v nginx >/dev/null 2>&1; then
    nginx -t || true
  else
    echo "nginx not installed"
  fi
  endcode

} > "${TMP_OUT}"

# Persist attachment
cp -f "${TMP_OUT}" "${ATT}"

# SHA256 tamper-evidence
SHA="$(sha256sum "${ATT}" | awk '{print $1}')"
echo "${SHA}  ${ATT}" >> "${HASH_LEDGER}"

# Append to long-running markdown audit files
{
  echo ""
  echo "---"
  echo "## Audit Run: ${TS}"
  echo ""
  echo "**Attachment:** ${ATT}"
  echo "**SHA256:** ${SHA}"
  echo ""
  cat "${TMP_OUT}"
} >> "${AUDIT_DEVOPS}"

cp -f "${AUDIT_DEVOPS}" "${AUDIT_APP}"

# ----------------------------
# Email (always includes attachment + SHA)
# ----------------------------
SUBJECT="Security Audit - ${DOMAIN} - ${TS}"
{
  echo "Security Audit Summary"
  echo "Timestamp (UTC): ${TS}"
  echo "Host: $(hostname -f 2>/dev/null || hostname)"
  echo ""
  echo "Attachment: ${ATT}"
  echo "SHA256: ${SHA}"
  echo ""
  echo "Key checks:"
  echo "- UFW status + listening sockets included in report."
  echo "- External nmap spot-check included in report."
{
  echo "Security Audit Report"
  echo "====================="
  echo ""
  echo "Host: ${HOSTNAME}"
  echo "Timestamp (UTC): ${TS}"
  echo ""
  echo "Report path (on server):"
  echo "  ${ATT}"
  echo ""
  echo "SHA256:"
  echo "  $(sha256sum "${ATT}" | awk '{print $1}')"
  echo ""
  echo "---------------------"
  echo ""
  cat "${ATT}"
} | mail -s "${SUBJECT}" "${EMAIL_TO}" < /dev/null || true

# Stdout for manual runs / cron logs
echo "DONE."
echo "Attachment: ${ATT}"
echo "SHA256: ${SHA}"
echo "SHA256 ledger: ${HASH_LEDGER}"
