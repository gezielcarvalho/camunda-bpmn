# Camunda 8 Development Environment

A complete Camunda 8 development stack with Docker Compose.

## Quick Start Commands

### First Time Setup

```bash
# Copy environment configuration
cp .env.example .env

# Start everything
./start.sh
```

### Manual Control

```bash
# Start services
docker compose up -d

# Stop services (keep data)
docker compose down

# Stop and remove all data
docker compose down -v

# Check health
./health-check.sh
```

### Useful Commands

```bash
# View logs
docker compose logs -f zeebe
docker compose logs -f operate
docker compose logs -f tasklist

# Deploy a BPMN file with zbctl
docker run --rm -it -v "$PWD/bpmn:/bpmn" --network host camunda/zbctl:8.6.3 \
  --address localhost:26500 deploy /bpmn/your-process.bpmn

# Check Zeebe status
docker run --rm -it --network host camunda/zbctl:8.6.3 \
  --address localhost:26500 status
```

## Access URLs

- **Operate**: http://localhost:8081 (Process monitoring)
- **Tasklist**: http://localhost:8082 (Human tasks)
- **Identity**: http://localhost:8084 (Authentication)
- **Elasticsearch**: http://localhost:9200 (user: `elastic`, pass: `changeme`)

## Default Credentials

- **Admin User**: `admin` / `admin`
- **Elasticsearch**: `elastic` / `changeme`

## Development Workflow

1. Place your BPMN files in the `bpmn/` directory
2. Use Camunda Modeler to connect to `localhost:26500`
3. Deploy and start process instances
4. Monitor in Operate, complete tasks in Tasklist

## Directory Structure

```
.
├── .env.example          # Environment configuration template
├── .env                  # Your local configuration (created from example)
├── docker-compose.yml    # Main service definitions
├── start.sh             # Quick start script
├── health-check.sh      # Service health checker
├── bpmn/                # Place your BPMN files here
├── backups/             # Elasticsearch snapshots
├── init/                # Bootstrap scripts
└── reverse-proxy/       # Optional proxy configuration
```
