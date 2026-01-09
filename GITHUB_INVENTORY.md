# GitHub Repository Inventory

**Generated**: 2026-01-09
**Organization**: Discoverant
**Total Repos**: 17

---

## Active Platform Repos

| Repo | URL | Description | Status |
|------|-----|-------------|--------|
| discoverant-frontend | https://github.com/Discoverant/discoverant-frontend | React frontend for Discoverant | **Active** |
| adroit-chemistry-rebuild | https://github.com/Discoverant/adroit-chemistry-rebuild | FastAPI backend + infrastructure | **Active** |
| adroit-brand-assets | https://github.com/Discoverant/adroit-brand-assets | Brand guide, logos, colors | Active |

---

## Client Websites (NEW - Backed Up Today)

| Repo | URL | Domain | Type |
|------|-----|--------|------|
| poppyherring-website | https://github.com/Discoverant/poppyherring-website | poppyherring.com | Static HTML |
| michellegormally-website | https://github.com/Discoverant/michellegormally-website | michellegormally.com | Static HTML |
| cumbriatattooremoval-website | https://github.com/Discoverant/cumbriatattooremoval-website | cumbriatattooremoval.com | Static HTML |
| adroitdi-website | https://github.com/Discoverant/adroitdi-website | adroitdi.com | Static HTML |
| richmond-dental-website | https://github.com/Discoverant/richmond-dental-website | richmond.arthurlingard.com | Static HTML |

---

## Arthur's Projects (NEW - Backed Up Today)

| Repo | URL | Description | Status |
|------|-----|-------------|--------|
| wobbly-london | https://github.com/Discoverant/wobbly-london | Multiplayer 3D game (Three.js) | Stopped |
| arthurlingard-website | https://github.com/Discoverant/arthurlingard-website | Personal portfolio (Node.js) | Running |

---

## Reference/Archive Repos

| Repo | URL | Description | Status |
|------|-----|-------------|--------|
| discoverant-lims | https://github.com/Discoverant/discoverant-lims | LIMS platform | Reference |
| sdf-recreation-aws | https://github.com/Discoverant/sdf-recreation-aws | AWS deployment scripts | Reference |
| adroit-sdf-pro | https://github.com/Discoverant/adroit-sdf-pro | Quantori source extraction | Reference |
| chemistry-platform | https://github.com/Discoverant/chemistry-platform | Old chemistry platform | Archive |
| discoverant-platform | https://github.com/Discoverant/discoverant-platform | Multi-tenant platform | Archive |
| adroit-backup-dec15 | https://github.com/Discoverant/adroit-backup-dec15 | Backup snapshot | Archive |
| Repository_eproduction- | https://github.com/Discoverant/Repository_eproduction- | Legacy | Archive |

---

## Server Mapping

| Domain | GitHub Repo | Server Location |
|--------|-------------|-----------------|
| app.discoverant.com | discoverant-frontend | ~/discoverant-frontend |
| app.discoverant.com/api | adroit-chemistry-rebuild | ~/adroit-chemistry-platform |
| poppyherring.com | poppyherring-website | /var/www/poppyherring.com |
| michellegormally.com | michellegormally-website | /var/www/michellegormally.com |
| cumbriatattooremoval.com | cumbriatattooremoval-website | /var/www/cumbriatattooremoval.com |
| adroitdi.com | adroitdi-website | /var/www/adroitdi |
| richmond.arthurlingard.com | richmond-dental-website | /var/www/richmond |
| arthurlingard.com | arthurlingard-website | ~/arthurlingard-website |
| app.arthurlingard.com | wobbly-london | ~/wobbly-london |

---

## Quick Commands

### Clone All Repos

```bash
# Clone all Discoverant repos
gh repo list Discoverant --limit 50 --json name -q '.[].name' | \
  xargs -I {} gh repo clone Discoverant/{}
```

### List All Repos

```bash
gh repo list Discoverant --limit 50
```

### Check Repo Status

```bash
for repo in discoverant-frontend adroit-chemistry-rebuild wobbly-london; do
  echo "=== $repo ==="
  gh repo view Discoverant/$repo --json updatedAt -q '.updatedAt'
done
```

---

## Server Details

| Property | Value |
|----------|-------|
| **External IP** | 137.220.101.182 |
| **Hostname** | lingard-OptiPlex-7060 |
| **OS** | Ubuntu 22.04 LTS |

---

## Backup Status

| Category | Count | Status |
|----------|-------|--------|
| Platform repos | 3 | All on GitHub |
| Client websites | 5 | **All on GitHub (NEW)** |
| Arthur's projects | 2 | **All on GitHub (NEW)** |
| Reference/Archive | 7 | All on GitHub |
| **Total** | **17** | **Complete** |

---

*Inventory updated 2026-01-09*
