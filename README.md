# Camunda 8 on Docker — Self-Managed Stack

Spin up a **Camunda 8** development environment locally using Docker Compose: **Zeebe** (workflow engine), **Operate**, **Tasklist**, and **Elasticsearch**.

> This repo is optimized for **local dev & staging**. See the **Production Hardening** section before exposing anything to the internet.

---

## Stack

- **Zeebe** – workflow engine (gRPC): `26500`
- **Operate** – monitoring & troubleshooting UI: `8081` (local auth: demo/demo)
- **Tasklist** – human task UI: `8082` (local auth: demo/demo)
- **Web Modeler** – visual BPMN editor: `3000` (optional)
- **Elasticsearch** – persistence for Operate/Tasklist: `9200`

_Note: Identity service is disabled by default for easier development._

### High-level topology

```
Clients (Web Modeler / Desktop Modeler / Code)  ->  Zeebe (gRPC 26500)
Web Modeler (3000)        ->  Zeebe (gRPC 26500)
Operate UI (8081)         ->  Elasticsearch (9200)
Tasklist UI (8082)        ->  Elasticsearch (9200)
[Identity (8084) - Optional for production]
```

---

## Prerequisites

- Docker **24+** and **Docker Compose** plugin
- 4+ GB RAM free (Elasticsearch is hungry)
- Open local ports: **26500, 3000, 8081, 8082, 9200**
- (Optional) Node.js 20+ for local Web Modeler development

---

## Repository Layout

```
.
├─ .env.example              # Version pins & dev creds (copy to .env)
├─ docker-compose.yml        # Core stack with local authentication
├─ docker-compose.auth.yml   # Optional Identity/SSO overlay
├─ docker-compose.modeler.yml # Optional Web Modeler overlay
├─ start.sh                  # Quick start script
├─ health-check.sh           # Service health checker
├─ QUICKSTART.md             # Quick reference guide
├─ CREDENTIALS.md            # Credentials reference
├─ bpmn/                     # BPMN workflow files
│  └─ hello-world.bpmn       # Example workflow
├─ docs/                     # Learning path tutorials
│  ├─ README.md              # Learning roadmap
│  ├─ step-00-setup.md       # Environment setup
│  ├─ step-01-getting-started.md  # First workflow tutorial
│  ├─ step-02-first-workflow.md   # End-to-end workflow guide
│  └─ web-modeler-quickstart.md   # Web Modeler guide
├─ web-modeler/              # Web-based BPMN modeler (Vue.js)
│  ├─ src/                   # Vue application source
│  ├─ Dockerfile             # Docker build config
│  ├─ package.json           # Dependencies
│  └─ README.md              # Web Modeler documentation
├─ reverse-proxy/            # (optional) Traefik/nginx config for TLS/hosts
├─ init/                     # Bootstrap scripts
└─ backups/                  # ES snapshots / volume backups
```

---

## Quick Start

1. **Clone & configure**

```bash
git clone https://github.com/gezielcarvalho/camunda-bpmn.git
cd camunda-bpmn
cp .env.example .env
# (optional) change passwords, image tags, memory settings
```

2. **Launch the stack**

```bash
# Using the quick start script (recommended)
./start.sh

# Or manually
docker compose up -d
docker compose ps
```

3. **Open the apps**

- **Operate**: [http://localhost:8081/operate](http://localhost:8081/operate) (user: `demo`, pass: `demo`)
- **Tasklist**: [http://localhost:8082/tasklist](http://localhost:8082/tasklist) (user: `demo`, pass: `demo`)
- **Elasticsearch** (secured): [http://localhost:9200](http://localhost:9200) (user: `elastic`, pass: from `.env`)

> First boot can take a minute while Elasticsearch warms up and the apps initialize.

4. **(Optional) Start Web Modeler**

```bash
# Start with Web Modeler
docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d

# Or run locally for development
cd web-modeler
npm install
npm run dev
```

- **Web Modeler**: [http://localhost:3000](http://localhost:3000)

5. **Check service health**

```bash
./health-check.sh
```

---

## Default Versions & Dev Credentials

Pinned in **`.env`** (edit as needed):

```dotenv
# Images (pin for repeatability)
ZEEBE_IMAGE=camunda/zeebe:8.6.3
OPERATE_IMAGE=camunda/operate:8.6.3
TASKLIST_IMAGE=camunda/tasklist:8.6.3
IDENTITY_IMAGE=camunda/identity:8.6.3
ELASTIC_IMAGE=elasticsearch:8.12.2

# Dev credentials (CHANGE IN PROD)
ELASTIC_PASSWORD=changeme
# Note: Operate/Tasklist use local auth (demo/demo)
```

---

## What's in `docker-compose.yml`?

- Single-node **Zeebe** (1 partition) with **Elasticsearch exporter** enabled
- **Elasticsearch** single node with security enabled
- **Operate** and **Tasklist** with local authentication (demo user)
- Persistent volumes for **Zeebe**, **Elasticsearch**, and **Identity**
- **Identity service disabled by default** for simplified development setup
- **Backup directory** mounted for Elasticsearch snapshots

> Zeebe's gRPC is exposed on `26500`, Operate on `8081`, Tasklist on `8082`.
> Identity service (port `8084`) can be enabled with `docker-compose.auth.yml` overlay.

---

## First Workflow in 2 Minutes

**Option A – Web Modeler (Easiest)**

1. Start Web Modeler:

   ```bash
   # With Docker
   docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d

   # Or locally
   cd web-modeler && npm install && npm run dev
   ```

2. Open [http://localhost:3000](http://localhost:3000)
3. Design your process using the visual editor
4. Click **🚀 Deploy to Zeebe**
5. Watch it in **Operate** (`demo`/`demo`); complete human tasks in **Tasklist** (`demo`/`demo`)

**Option B – Desktop Modeler (Full-Featured)**

1. Download [Camunda Modeler](https://camunda.com/download/modeler/)
2. Open the included example: `bpmn/hello-world.bpmn`
3. Set Zeebe connection to `localhost:26500` (no authentication required)
4. Click **Deploy**, then **Start Instance**
5. Watch it in **Operate** (`demo`/`demo`); complete human tasks in **Tasklist** (`demo`/`demo`)

**Option C – `zbctl` (Command Line)**

```bash
# Install zbctl
wget https://github.com/camunda/zeebe/releases/download/8.6.3/zbctl
chmod +x zbctl && sudo mv zbctl /usr/local/bin/

# Check gateway status
zbctl --address localhost:26500 status

# Deploy the example BPMN file
zbctl --address localhost:26500 deploy bpmn/hello-world.bpmn

# Start a process instance
zbctl --address localhost:26500 create instance hello-world
```

**See the tutorials** in `docs/` for step-by-step learning path.

---

## Common Commands

```bash
# Start / stop
./start.sh                         # Quick start with setup
docker compose up -d               # Start services
docker compose down                # Stop (keep volumes)
docker compose down -v             # ⚠️ deletes data

# Start with Web Modeler
docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d

# Health check
./health-check.sh                  # Check all services

# Logs
docker compose logs -f zeebe
docker compose logs -f operate
docker compose logs -f tasklist
docker compose logs -f elasticsearch
docker compose logs -f web-modeler # If using Web Modeler

# Service endpoints
curl -s http://localhost:8081/operate
curl -s http://localhost:8082/tasklist
curl -s http://localhost:3000      # Web Modeler
curl -u elastic:changeme http://localhost:9200
nc -zv localhost 26500             # Test Zeebe gRPC port

# Enable Identity/SSO (optional)
docker compose -f docker-compose.yml -f docker-compose.auth.yml up -d
```

---

## Configuration Reference

### Ports

| Service       | Port (host\:container) | Notes                   |
| ------------- | ---------------------- | ----------------------- |
| Zeebe gRPC    | 26500:26500            | Clients & Modeler       |
| Zeebe metrics | 9600:9600              | Prometheus scrape (opt) |
| Operate       | 8081:8080              | Web UI (demo/demo)      |
| Tasklist      | 8082:8080              | Web UI (demo/demo)      |
| Web Modeler   | 3000:80                | BPMN editor (optional)  |
| Elasticsearch | 9200:9200              | Secured; `elastic` user |

### Key environment variables (excerpt)

- `ZEEBE_IMAGE`, `OPERATE_IMAGE`, `TASKLIST_IMAGE`, `IDENTITY_IMAGE`, `ELASTIC_IMAGE` – Container image versions
- `ELASTIC_PASSWORD` – Elasticsearch password (default: `changeme`)
- `ZEEBE_BROKER_CLUSTER_*` – partitions/replication/size (dev defaults: `1/1/1`)
- `ES_JAVA_OPTS` – JVM options for Elasticsearch (default: `-Xms1g -Xmx1g`)
- `CAMUNDA_OPERATE_*` / `CAMUNDA_TASKLIST_*` – ES URL and Zeebe address
- `CAMUNDA_OPERATE_USER_*` / `CAMUNDA_TASKLIST_USER_*` – Local user configuration (demo/demo)
- `KEYCLOAK_*` – Identity/SSO configuration (when using auth overlay)

All configurable in `.env` file (copy from `.env.example`).

---

## 📚 Learning Path

New to Camunda 8? This repository includes a comprehensive learning path:

- **[Step 00: Environment Setup](docs/step-00-setup.md)** - Complete setup and verification
- **[Step 01: Getting Started](docs/step-01-getting-started.md)** - Your first BPMN workflow
- **[Step 02: First End-to-End Workflow](docs/step-02-first-workflow.md)** - Build a complete process
- **[Web Modeler Quick Start](docs/web-modeler-quickstart.md)** - Use the web-based modeler
- **[Learning Roadmap](docs/README.md)** - Full learning path overview

Perfect for beginners and experienced developers alike!

---

## Production Hardening (Checklist)

- **Credentials**: Replace all default passwords and rotate secrets.
- **TLS & Hostnames**: Place a reverse proxy (Traefik/nginx) in front; use Let’s Encrypt or a wildcard cert.
- **Network**: Keep services on an internal Docker network; expose only the proxy.
- **Persistence**:

  - Back up **Zeebe data** volume (RocksDB state) regularly.
  - Configure **Elasticsearch snapshots** (see next section).

- **Resources**:

  - Increase memory/CPU; pin JVM options for ES and Java services.
  - Disable swap for ES; set `memlock` and use `mmap` FS.

- **Observability**:

  - Scrape Prometheus metrics (Zeebe, Operate, Tasklist).
  - Aggregate logs (e.g., Loki/ELK).

- **Scaling**:

  - Move to multi-broker Zeebe and a 3-node ES cluster for HA.
  - Consider Kubernetes once the models & load stabilize.

---

## Backup & Restore

### Elasticsearch snapshots (recommended)

1. Mount a host dir for snapshots (e.g., `./backups/es`).
2. Register a snapshot repo via the ES API (once).
3. Schedule snapshots via cron or CI.

Example (registering a filesystem repo):

```bash
curl -u elastic:$ELASTIC_PASSWORD -X PUT "http://localhost:9200/_snapshot/es_local" \
  -H 'Content-Type: application/json' \
  -d '{"type":"fs","settings":{"location":"/usr/share/elasticsearch/backup"}}'
```

> Ensure `docker-compose.yml` maps `./backups/es:/usr/share/elasticsearch/backup`.

### Zeebe state

- Stop containers cleanly, then archive the **`zeebe-data`** volume directory.
- For hot backups, prefer cluster replication or the official backup exporter (enterprise) if available.

---

## Upgrades

1. **Read release notes** for your target versions.
2. **Back up** ES snapshots + Zeebe data.
3. **Bump tags** in `.env` (ES first if required by new Operate/Tasklist).
4. `docker compose pull && docker compose up -d`
5. Verify health endpoints & UIs.

---

## Troubleshooting

- **Operate/Tasklist login issues**

  - Use credentials: `demo` / `demo` for both services (see `CREDENTIALS.md`)
  - Ensure Zeebe is exporting to Elasticsearch (exporter enabled in compose)
  - Check `OPERATE_ELASTICSEARCH_*` / `TASKLIST_ELASTICSEARCH_*` environment variables

- **Want to enable Identity/SSO?**

  - Identity service is disabled by default for simplified development
  - Enable with overlay: `docker compose -f docker-compose.yml -f docker-compose.auth.yml up -d`
  - Access Identity at `http://localhost:8084` (user: `admin`, pass: `admin`)

- **Elasticsearch refuses connections**

  - Verify `ELASTIC_PASSWORD` matches across services (default: `changeme`)
  - Ensure enough RAM; try increasing `ES_JAVA_OPTS=-Xms2g -Xmx2g` in `.env`
  - Check logs: `docker compose logs -f elasticsearch`

- **Modeler cannot deploy**

  - Confirm Zeebe at `localhost:26500`
  - Test with: `nc -zv localhost 26500`
  - Or use `zbctl --address localhost:26500 status`

- **Services won't start**

  - Run health check: `./health-check.sh`
  - Check Docker resources (4+ GB RAM required)
  - Verify ports are not in use: `netstat -an | grep "26500\|8081\|8082\|9200"`
  - Check logs: `docker compose logs`

---

## (Optional) Reverse Proxy Snippet (Traefik)

To serve `https://operate.example.com`, add a Traefik service and labels, terminate TLS at Traefik, and route to Operate/Tasklist/Identity. See `reverse-proxy/` for an example.

---

## FAQ

**Q: Camunda 7 or 8?**
A: This repo is for **Camunda 8** (Zeebe-based). Camunda 7 is the classic engine and not supported here.

**Q: Can I skip Identity for dev?**
A: Yes. This setup runs **without Identity by default** for easier development. Enable it later with the auth overlay file.

**Q: Where do I change versions?**
A: Edit **`.env`** to pin image tags. Copy from `.env.example` first.

**Q: How do I backup my data?**
A: Use Elasticsearch snapshots (see Backup & Restore section) and backup Zeebe volumes.

**Q: What's the difference between this and Camunda Cloud?**
A: This is self-managed/self-hosted. Camunda Cloud is the SaaS offering. This gives you full control over your infrastructure.

**Q: Can I use this in Windows?**
A: Yes! Use Docker Desktop for Windows. The scripts are bash-based, so use Git Bash or WSL.

**Q: Do I need to download Camunda Modeler?**
A: No! This repo includes a **Web Modeler** (Vue.js-based) that runs in your browser. You can also download the desktop version if you prefer.

**Q: How do I customize the Web Modeler?**
A: The Web Modeler is a Vue.js application in `web-modeler/`. You can modify the code, add features, and extend it as needed. See `web-modeler/README.md` for details.

---

## Additional Resources

- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference guide
- **[CREDENTIALS.md](CREDENTIALS.md)** - All login credentials
- **[Learning Path](docs/README.md)** - Structured tutorials
- **[Web Modeler Guide](web-modeler/README.md)** - Web Modeler documentation
- **[Camunda 8 Docs](https://docs.camunda.io/)** - Official documentation
- **[BPMN 2.0 Reference](https://camunda.com/bpmn/)** - BPMN modeling guide
- **[Camunda Forum](https://forum.camunda.io/)** - Community support

---

## License

MIT License - See `LICENSE` file for details.

---

## Contributing

Contributions welcome! Feel free to:

- Report issues
- Submit pull requests
- Suggest improvements
- Share your workflows

---

## Credits & Acknowledgments

Camunda® is a registered trademark of Camunda Services GmbH.

This project is a community setup for local/staging use, created to help developers get started with Camunda 8 quickly and easily.

**Repository**: [github.com/gezielcarvalho/camunda-bpmn](https://github.com/gezielcarvalho/camunda-bpmn)
