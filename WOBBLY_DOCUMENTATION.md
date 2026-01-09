# Wobbly London - Complete Documentation

**Last Updated**: 2026-01-09
**Status**: Stopped (containers disabled)

---

## Overview

Wobbly London is a multiplayer 3D game built for Arthur's son. Players explore a virtual London as physics-based "wobbly" characters, completing missions and interacting with other players.

### Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | Three.js + Socket.io | 3D rendering, real-time multiplayer |
| **Backend** | Node.js + Express | Game server, API |
| **Database** | PostgreSQL 15 | Player data, mission progress |
| **Cache** | Redis 7 | Session state, position caching |
| **Container** | Docker + Docker Compose | Deployment |

---

## Architecture

```
                    Browser
                       │
                       ▼
              ┌─────────────────┐
              │  nginx (443)    │
              │  SSL + proxy    │
              └────────┬────────┘
                       │
         ┌─────────────┴─────────────┐
         │                           │
         ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│  PROD (3002)    │        │  DEV (3003)     │
│  wobbly-london  │        │  wobbly-london  │
│  -prod          │        │  -dev           │
└────────┬────────┘        └────────┬────────┘
         │                          │
         └──────────┬───────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
         ▼                     ▼
┌─────────────────┐   ┌─────────────────┐
│  PostgreSQL     │   │  Redis          │
│  Port 5434      │   │  Port 6380      │
│  wobbly-postgres│   │  wobbly-redis   │
└─────────────────┘   └─────────────────┘
```

---

## Port Allocation

| Port | Service | Container | Status |
|------|---------|-----------|--------|
| 3002 | Production game | wobbly-london-prod | **Stopped** |
| 3003 | Development game | wobbly-london-dev | **Stopped** |
| 5434 | PostgreSQL | wobbly-postgres | **Stopped** |
| 6380 | Redis | wobbly-redis | **Stopped** |

---

## Docker Containers

### Current Status (All Stopped)

| Container | Image | Purpose |
|-----------|-------|---------|
| wobbly-london-prod | wobbly-london_wobbly-london-prod | Production game server |
| wobbly-london-dev | wobbly-london_wobbly-london-dev | Development game server |
| wobbly-postgres | postgres:15-alpine | Player database |
| wobbly-redis | redis:7-alpine | Session cache |
| wobbly-backup | postgres:15-alpine | Database backup (broken) |
| wobbly-game | wobbly-london_game | Game container (broken) |
| wobbly-grafana | grafana/grafana:latest | Monitoring (broken) |
| wobbly-prometheus | prom/prometheus:latest | Metrics (broken) |
| wobbly-nginx | nginx:alpine | Reverse proxy (unused) |

### Known Issues

| Container | Issue | Fix Required |
|-----------|-------|--------------|
| wobbly-backup | Read-only filesystem | Fix volume mount |
| wobbly-grafana | Permission denied on /var/lib/grafana | Fix volume ownership |
| wobbly-prometheus | Permission denied on /prometheus | Fix volume ownership |

---

## Directory Structure

```
~/wobbly-london/              # Main source directory
├── docker-compose.yml        # Container orchestration
├── Dockerfile               # Container build
├── DEPLOYMENT.md            # Original deployment guide
├── WOBBLY_DOCUMENTATION.md  # This file
├── package.json             # Node.js dependencies
├── server.js                # Main game server
├── public/                  # Static assets
│   ├── index.html          # Game client
│   ├── admin.html          # Admin panel
│   ├── css/                # Stylesheets
│   ├── js/                 # Client JavaScript
│   └── models/             # 3D models
├── database/               # DB scripts
└── scripts/                # Deployment scripts

~/wobbly-data/               # Data volumes
├── postgres/               # PostgreSQL data
├── redis/                  # Redis data
├── grafana/               # Grafana data
├── prometheus/            # Prometheus data
├── backups/               # Database backups
└── game-data/             # Game state
```

---

## Game Features

### Gameplay
- **Movement**: WASD keys + mouse look
- **Jump**: Spacebar
- **Interact**: E key
- **Chat**: Enter to type

### Missions
| ID | Mission | Target | Reward |
|----|---------|--------|--------|
| 1 | Visit St Paul's Cathedral | (0, 0, -100) | 100 pts |
| 2 | Explore Shoreditch | (150, 0, 50) | 150 pts |
| 3 | Cross the Thames | (-50, 0, -50) | 75 pts |
| 4 | Find the Market | (100, 0, 100) | 125 pts |

### Multiplayer
- Real-time position sync via Socket.io
- Player colors randomly assigned
- Chat system
- Score leaderboard

---

## Database Schema

### PostgreSQL Tables

```sql
-- Player records
CREATE TABLE players (
    id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255),
    score INTEGER DEFAULT 0,
    missions_completed INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mission completions
CREATE TABLE player_missions (
    id SERIAL PRIMARY KEY,
    player_id VARCHAR(255),
    mission_id INTEGER,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## How to Start

### Start All Containers

```bash
cd ~/wobbly-london

# Enable restart policy
docker update --restart=unless-stopped \
    wobbly-london-prod wobbly-london-dev \
    wobbly-postgres wobbly-redis

# Start containers
docker start wobbly-postgres wobbly-redis
sleep 5  # Wait for databases
docker start wobbly-london-prod wobbly-london-dev

# Verify
docker ps | grep wobbly
```

### Start with Docker Compose

```bash
cd ~/wobbly-london
docker-compose up -d
```

---

## How to Stop

```bash
# Stop game containers
docker stop wobbly-london-prod wobbly-london-dev

# Stop databases (optional)
docker stop wobbly-postgres wobbly-redis

# Disable auto-restart
docker update --restart=no \
    wobbly-london-prod wobbly-london-dev \
    wobbly-postgres wobbly-redis
```

---

## Access URLs

### When Running

| Environment | Internal URL | External URL |
|-------------|--------------|--------------|
| Production | http://localhost:3002 | https://app.arthurlingard.com |
| Development | http://localhost:3003 | N/A |

### Nginx Config

Production is exposed via `app.arthurlingard.com`:

```nginx
# /etc/nginx/sites-enabled/app.arthurlingard
server {
    listen 443 ssl http2;
    server_name app.arthurlingard.com;

    location / {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
    }
}
```

---

## Dependencies

### Node.js Packages

```json
{
    "express": "^4.18.2",
    "socket.io": "^4.7.2",
    "pg": "^8.11.3",
    "redis": "^4.6.10",
    "uuid": "^9.0.1"
}
```

### Docker Images

- `node:18-alpine` (via Dockerfile)
- `postgres:15-alpine`
- `redis:7-alpine`

---

## Backup & Restore

### Database Backup

```bash
# Backup
docker exec wobbly-postgres pg_dump -U postgres wobbly_london_prod > backup.sql

# Restore
docker exec -i wobbly-postgres psql -U postgres wobbly_london_prod < backup.sql
```

### Full Backup

```bash
# Backup entire wobbly-london directory
tar -czvf wobbly-london-backup-$(date +%Y%m%d).tar.gz ~/wobbly-london/

# Backup data volumes
tar -czvf wobbly-data-backup-$(date +%Y%m%d).tar.gz ~/wobbly-data/
```

---

## Git Repository

**Status**: NOT on GitHub

**Recommendation**: Create repository at `Discoverant/wobbly-london` or personal account.

```bash
# Initialize git repo
cd ~/wobbly-london
git init
git add .
git commit -m "Initial commit: Wobbly London game"

# Push to GitHub (after creating repo)
git remote add origin https://github.com/YOUR_ACCOUNT/wobbly-london.git
git push -u origin main
```

---

## Troubleshooting

### Game Won't Start

1. Check if databases are running:
   ```bash
   docker ps | grep -E "wobbly-postgres|wobbly-redis"
   ```

2. Check container logs:
   ```bash
   docker logs wobbly-london-prod --tail 50
   ```

3. Test database connection:
   ```bash
   docker exec wobbly-postgres psql -U postgres -c "SELECT 1;"
   ```

### Players Can't Connect

1. Check nginx is running:
   ```bash
   sudo systemctl status nginx
   ```

2. Test local access:
   ```bash
   curl http://localhost:3002
   ```

3. Check firewall:
   ```bash
   sudo ufw status
   ```

---

*Documentation generated 2026-01-09*
