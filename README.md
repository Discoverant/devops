# 🖥️ Discoverant DevOps

Server operations dashboard and infrastructure documentation.

## Live Dashboard
https://ops.adroitdi.com

## Architecture
```
Internet -> Router -> Nginx (:80/:443) -> Services
                              |
              +---------------+---------------+
              |               |               |
          Frontend:3100   Backend:8000   Static Sites
              |               |
              +-------+-------+
                      |
              +-------+-------+
              |       |       |
          Postgres  Redis  Elastic
           :5432    :6379   :9200
```

## Server
| Spec | Value |
|------|-------|
| Hostname | lingard-OptiPlex-7060 |
| Public IP | 137.220.101.182 |
| OS | Ubuntu 22.04 LTS |
| CPU | 12 cores |
| RAM | 32GB |

## Sites Managed (9)
| Site | Purpose |
|------|---------|
| app.discoverant.com | Main platform |
| dev.discoverant.com | Development |
| adroitdi.com | Company site |
| ops.adroitdi.com | This dashboard |
| poppyherring.com | Client site |
| michellegormally.com | Client site |
| cumbriatattooremoval.com | Client site |
| arthurlingard.com | Personal site |
| richmond.arthurlingard.com | Client site |

## Docker Services
| Container | Port | Status |
|-----------|------|--------|
| discoverant-frontend | 3100 | Running |
| adroit-backend | 8000 | Running |
| adroit-postgres | 5432 | Running |
| adroit-redis | 6379 | Running |
| adroit-elasticsearch | 9200 | Running |
| wobbly-london | - | Stopped |

## Port Registry
| Port | Service |
|------|---------|
| 80 | nginx HTTP |
| 443 | nginx HTTPS |
| 3100 | Frontend |
| 8000 | Backend API |
| 5432 | PostgreSQL |
| 6379 | Redis |
| 9200 | Elasticsearch |

## Maintenance Commands
```bash
# Check containers
docker ps

# Restart frontend
pm2 restart discoverant-frontend

# Restart backend
docker restart adroit-backend

# Check nginx
sudo nginx -t && sudo systemctl reload nginx

# SSL certs
sudo certbot certificates
```

## Documentation
- [PORT_REGISTRY.md](PORT_REGISTRY.md)
- [GITHUB_INVENTORY.md](GITHUB_INVENTORY.md)
- [WOBBLY_DOCUMENTATION.md](WOBBLY_DOCUMENTATION.md)

## GitHub Repos (18)
https://github.com/Discoverant

## Contact
Richard Lingard - richard@adroitdi.com

---
*Adroit DI - 2026*

## Family Sites
| Site | Purpose |
|------|---------|
| thelingards.com | Family website / Events |
