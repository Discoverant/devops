# Port Registry

> Last updated: January 2026

## Active Ports

| Port | Service | Container/Process | Purpose |
|------|---------|-------------------|---------|
| 22 | SSH | sshd | Remote access |
| 80 | HTTP | nginx | Web (redirects to 443) |
| 443 | HTTPS | nginx | Web (SSL termination) |
| 3000 | SDFE Frontend | sdfe-frontend | Quantori reference UI |
| 3004 | Arthur Website | arthur-live | arthurlingard.com |
| 3100 | Discoverant Frontend | node (PM2) | app.discoverant.com |
| 3201 | Chemistry Frontend | chemistry-new-frontend | Legacy chemistry UI |
| 3389 | RDP | xrdp | Remote desktop |
| 5432 | PostgreSQL | adroit-postgres | Main database |
| 6379 | Redis | adroit-redis | Cache |
| 8000 | FastAPI Backend | adroit-backend | API server |
| 9200 | Elasticsearch | adroit-elasticsearch | Search engine |

## Domain to Port Mapping

| Domain | Nginx Proxy To | Service |
|--------|----------------|---------|
| app.discoverant.com | 3100 (frontend) + 8000 (api) | Discoverant Platform |
| app.adroitrepository.com | 3000 (frontend) + 8000 (api) | SDFE Reference |
| dev.discoverant.com | 3100 | Development |
| arthurlingard.com | 3004 | Arthur's Site |
| richmond.arthurlingard.com | static | Richmond Dental |
| adroitdi.com | static | Company Site |
| ops.adroitdi.com | static | This Dashboard |
| poppyherring.com | static | Client Site |
| michellegormally.com | static | Client Site |
| cumbriatattooremoval.com | static | Client Site |

## Docker Containers

| Container | Image | Port Mapping | Status |
|-----------|-------|--------------|--------|
| adroit-backend | python:3.11 | 8000:8000 | Running |
| adroit-postgres | postgres:15 | 5432:5432 | Running |
| adroit-redis | redis:7 | 6379:6379 | Running |
| adroit-elasticsearch | elasticsearch:7.17 | 9200:9200 | Running |
| sdfe-frontend | ECR image | 3000:80 | Running |
| chemistry-new-frontend | node | 3201:80 | Running |
| arthur-live | node | 3004:3000 | Running |
| adroit-auth-proxy | - | none | Running |

## Available Ports

These ports are free for new services:

- 3002, 3003 (previously Wobbly)
- 3005-3099
- 5433+ (additional databases)
- 8001-8099 (additional APIs)

## Static Sites (served by nginx)

| Directory | Domain |
|-----------|--------|
| /var/www/ops.adroitdi.com | ops.adroitdi.com |
| /var/www/adroitdi | adroitdi.com |
| /var/www/poppyherring.com/html | poppyherring.com |
| /var/www/michellegormally.com/html | michellegormally.com |
| /var/www/cumbriatattooremoval.com/html | cumbriatattooremoval.com |
| /var/www/richmond | richmond.arthurlingard.com |

## System Services

| Port | Service | Purpose |
|------|---------|---------|
| 631 | CUPS | Printing |
| 5939 | TeamViewer | Remote support |
| 8384 | Syncthing | File sync (local only) |
| 22000 | Syncthing | File sync P2P |
