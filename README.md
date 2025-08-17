# Camunda 8 on Docker — Self-Managed Stack

Spin up a **Camunda 8** development environment locally using Docker Compose: **Zeebe** (workflow engine), **Operate**, **Tasklist**, **Identity** (OIDC), and **Elasticsearch**.

> This repo is optimized for **local dev & staging**. See the **Production Hardening** section before exposing anything to the internet.

---

## Stack

- **Zeebe** – workflow engine (gRPC): `26500`
- **Operate** – monitoring & troubleshooting UI: `8081`
- **Tasklist** – human task UI: `8082`
- **Identity** – authentication & OIDC provider: `8084`
- **Elasticsearch** – persistence for Operate/Tasklist: `9200`

### High-level topology

```
Clients (Modeler / Code)  ->  Zeebe (gRPC 26500)
Operate UI (8081)         ->  Elasticsearch (9200)
Tasklist UI (8082)        ->  Elasticsearch (9200)
Identity (8084)           ->  Zeebe + Elasticsearch
```

---

## Prerequisites

- Docker **24+** and **Docker Compose** plugin
- 4+ GB RAM free (Elasticsearch is hungry)
- Open local ports: **26500, 8081, 8082, 8084, 9200**

---

## Repository Layout

```
.
├─ .env.example          # Version pins & dev creds (copy to .env)
├─ docker-compose.yml    # Core stack
├─ reverse-proxy/        # (optional) Traefik/nginx config for TLS/hosts
├─ init/                 # (optional) bootstrap scripts
└─ backups/              # ES snapshots / volume backups
```

---

## Quick Start

1. **Clone & configure**

```bash
git clone <this-repo-url> camunda-docker
cd camunda-docker
cp .env.example .env
# (optional) change passwords, image tags, memory settings
```

2. **Launch the stack**

```bash
docker compose up -d
docker compose ps
```

3. **Open the apps**

- **Operate**: [http://localhost:8081](http://localhost:8081)
- **Tasklist**: [http://localhost:8082](http://localhost:8082)
- **Identity**: [http://localhost:8084](http://localhost:8084)
- **Elasticsearch** (secured): [http://localhost:9200](http://localhost:9200) (user: `elastic`, pass: from `.env`)

> First boot can take a minute while Elasticsearch warms up and the apps initialize.

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
IDP_ADMIN_USER=admin
IDP_ADMIN_PASSWORD=admin
```

---

## What’s in `docker-compose.yml`?

- Single-node **Zeebe** (1 partition) with **Elasticsearch exporter** enabled
- **Elasticsearch** single node with security enabled
- **Operate**, **Tasklist**, **Identity** wired to Elasticsearch and Zeebe
- Persistent volumes for **Zeebe** and **Elasticsearch**

> For clarity, Zeebe’s gRPC is exposed on `26500`, Operate on `8081`, Tasklist on `8082`, Identity on `8084`.

---

## First Workflow in 2 Minutes

**Option A – Camunda Modeler**

1. Open your BPMN in Modeler.
2. Set Zeebe connection to `localhost:26500`.
3. Click **Deploy**, then **Start Instance**.
4. Watch it in **Operate**; complete human tasks in **Tasklist**.

**Option B – `zbctl` (inside a container)**

```bash
# Check gateway status
docker run --rm -it --network host camunda/zbctl:8.6.3 \
  --address 0.0.0.0:26500 status

# Deploy a BPMN file from your current dir
docker run --rm -it -v "$PWD:/bpmn" --network host camunda/zbctl:8.6.3 \
  --address 0.0.0.0:26500 deploy /bpmn/your-process.bpmn
```

---

## Common Commands

```bash
# Start / stop
docker compose up -d
docker compose down               # keep volumes
docker compose down -v            # ⚠️ deletes data

# Logs
docker compose logs -f zeebe
docker compose logs -f operate
docker compose logs -f tasklist
docker compose logs -f identity
docker compose logs -f elasticsearch

# Health checks
curl -s http://localhost:8081/actuator/health
curl -s http://localhost:8082/actuator/health
curl -u elastic:$ELASTIC_PASSWORD http://localhost:9200
```

---

## Configuration Reference

### Ports

| Service       | Port (host\:container) | Notes                   |
| ------------- | ---------------------- | ----------------------- |
| Zeebe gRPC    | 26500:26500            | Clients & Modeler       |
| Zeebe metrics | 9600:9600              | Prometheus scrape (opt) |
| Operate       | 8081:8080              | Web UI                  |
| Tasklist      | 8082:8080              | Web UI                  |
| Identity      | 8084:8080              | IdP & admin             |
| Elasticsearch | 9200:9200              | Secured; `elastic` user |

### Key environment variables (excerpt)

- `ZEEBE_BROKER_CLUSTER_*` – partitions/replication/size (dev defaults: `1/1/1`)
- `CAMUNDA_OPERATE_*` / `CAMUNDA_TASKLIST_*` – ES URL and Zeebe address
- `IDENTITY_*` / `KEYCLOAK_INIT_*` – Identity configuration
- `ELASTIC_PASSWORD` – sets the `elastic` superuser password

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

- **Operate/Tasklist show empty data**

  - Ensure Zeebe is exporting to Elasticsearch (exporter enabled in compose).
  - Check `OPERATE_ELASTICSEARCH_*` / `TASKLIST_ELASTICSEARCH_*`.

- **Identity not reachable**

  - Wait 30–60s on first boot.
  - Check `docker compose logs -f identity`.

- **Elasticsearch refuses connections**

  - Verify `ELASTIC_PASSWORD` matches across services.
  - Ensure enough RAM; try `ES_JAVA_OPTS=-Xms1g -Xmx1g` (increase if you can).

- **Modeler cannot deploy**

  - Confirm Zeebe at `localhost:26500`.
  - Test with `zbctl ... status` (see commands above).

---

## (Optional) Reverse Proxy Snippet (Traefik)

To serve `https://operate.example.com`, add a Traefik service and labels, terminate TLS at Traefik, and route to Operate/Tasklist/Identity. See `reverse-proxy/` for an example.

---

## FAQ

**Q: Camunda 7 or 8?**
A: This repo is for **Camunda 8** (Zeebe). Camunda 7 is the classic engine and not supported here.

**Q: Can I skip Identity for dev?**
A: Yes. You can run Operate/Tasklist without OIDC early on and enable Identity later.

**Q: Where do I change versions?**
A: Edit **`.env`** to pin image tags.

---

## License

MIT (or your chosen license). See `LICENSE`.

---

## Credits

Camunda® is a registered trademark of Camunda Services GmbH. This project is a community setup for local/staging use.
