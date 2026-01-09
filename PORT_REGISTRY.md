# Port Registry - Single Source of Truth

**Last Updated**: 2026-01-09
**Server**: 137.220.101.182 (lingard-OptiPlex-7060)

---

## Active Ports

### Web Servers (nginx)

| Port | Service | Status |
|------|---------|--------|
| 80 | nginx HTTP | Running (redirects to HTTPS) |
| 443 | nginx HTTPS | Running (reverse proxy) |

### Discoverant Platform (PRODUCTION)

| Port | Service | Container/Process | Status |
|------|---------|-------------------|--------|
| **3100** | Discoverant Frontend | PM2 node | **ACTIVE** |
| **8000** | Backend API | adroit-backend | **ACTIVE** |
| **5432** | PostgreSQL + Bingo | adroit-postgres | **ACTIVE** |
| **6379** | Redis | adroit-redis | **ACTIVE** |
| **9200** | Elasticsearch | adroit-elasticsearch | **ACTIVE** |

### Reference/Legacy (Can Remove)

| Port | Service | Container | Status | Notes |
|------|---------|-----------|--------|-------|
| 3000 | SDFE Frontend | sdfe-frontend | Running | Reference only |
| 3201 | Chemistry New | chemistry-new-frontend | Running | Old dev frontend |

### Personal Sites

| Port | Service | Container | Status |
|------|---------|-----------|--------|
| 3004 | Arthur Website | arthur-live | Running |

### Reserved (Not Yet Built)

| Port | Service | Status |
|------|---------|--------|
| **3500** | Ops Dashboard | RESERVED - nothing listening |

### System Services

| Port | Service | Process |
|------|---------|---------|
| 22 | SSH | sshd |
| 53 | DNS | systemd-resolved |
| 631 | CUPS | printing |
| 3389 | RDP | xrdp |
| 5939 | TeamViewer | teamviewer |
| 8384 | Syncthing Web | syncthing |
| 22000 | Syncthing Sync | syncthing |

---

## Stopped (Freed Ports)

| Port | Was | Container | Status |
|------|-----|-----------|--------|
| 3002 | Wobbly Prod | wobbly-london-prod | **STOPPED** |
| 3003 | Wobbly Dev | wobbly-london-dev | **STOPPED** |
| 5434 | Wobbly DB | wobbly-postgres | **STOPPED** |
| 6380 | Wobbly Redis | wobbly-redis | **STOPPED** |

---

## Available Ports

| Range | Notes |
|-------|-------|
| 3002-3003 | Freed from Wobbly |
| 3005-3099 | Unused |
| 3102-3199 | Unused |
| 3202-3499 | Unused |
| 3501-3999 | Unused |

---

## Nginx Routing Table

### Proxy Routes (Dynamic)

| Domain | Path | Routes To | Service |
|--------|------|-----------|---------|
| app.discoverant.com | `/api/` | 127.0.0.1:8000 | Backend API |
| app.discoverant.com | `/` | 127.0.0.1:3100 | Frontend |
| arthurlingard.com | `/` | localhost:3004 | Arthur site |
| app.arthurlingard.com | `/` | localhost:3002 | **BROKEN** (Wobbly stopped) |

### Static Sites (root directive)

| Domain | Root Directory |
|--------|----------------|
| adroitdi.com | /var/www/adroitdi |
| discoverant.com | /var/www/discoverant |
| poppyherring.com | /var/www/poppyherring.com/html |
| michellegormally.com | /var/www/michellegormally.com/html |
| richmond.arthurlingard.com | /var/www/richmond |

---

## Port Test Results

| Port | Response |
|------|----------|
| 3000 | SDFE React app |
| 3100 | Discoverant React app |
| 3201 | Chemistry Vite app |
| 3500 | **NOTHING** (reserved) |
| 8000 | API JSON response |

---

## Issues Found

### 1. app.arthurlingard.com Routes to Stopped Container

```
proxy_pass http://localhost:3002;  # wobbly-london-prod is STOPPED
```

**Fix**: Either restart Wobbly or update nginx to serve static page.

### 2. ops.adroitdi.com Not Configured

- DNS: Points to this server (137.220.101.182)
- Nginx: No config file exists
- SSL: No certificate
- App: Nothing on port 3500

**Fix**: Run setup commands with sudo.

---

## Commands

### Check Single Port

```bash
# What's on port X?
ss -tlnp | grep ":3100"
docker ps | grep 3100
```

### Full Audit

```bash
# All listening ports
ss -tlnp | grep LISTEN

# All docker port mappings
docker ps --format "{{.Names}}\t{{.Ports}}"

# All nginx routes
grep -r "proxy_pass\|root " /etc/nginx/sites-enabled/
```

### Before Adding New Service

1. Check this registry for conflicts
2. Update this file with new port
3. Test with `curl http://localhost:PORT`
4. Add nginx config if needed
5. Get SSL cert if public

---

## Change Log

| Date | Change | Ports Affected |
|------|--------|----------------|
| 2026-01-09 | Stopped Wobbly containers | 3002, 3003, 5434, 6380 freed |
| 2026-01-09 | Reserved ops dashboard | 3500 reserved |
| 2026-01-09 | Created port registry | - |

---

*Keep this file updated!*
