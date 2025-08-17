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

# For zbctl commands, you need to install it separately or use Camunda Modeler
# Alternatively, you can install zbctl:
# wget https://github.com/camunda/zeebe/releases/download/8.6.3/zbctl
# chmod +x zbctl && sudo mv zbctl /usr/local/bin/

# Check Zeebe port accessibility
nc -zv localhost 26500
```

## Access URLs (Development Mode - Local Authentication)

- **Operate**: http://localhost:8081/operate (Process monitoring)
  - Username: `demo`
  - Password: `demo`
- **Tasklist**: http://localhost:8082/tasklist (Human tasks)
  - Username: `demo`
  - Password: `demo`
- **Elasticsearch**: http://localhost:9200 (user: `elastic`, pass: `changeme`)
- **Zeebe gRPC**: localhost:26500 (for Camunda Modeler and zbctl)

## Authentication (Optional)

By default, the stack runs without authentication for easy development. To enable authentication:

```bash
# Stop current services
docker compose down

# Start with authentication enabled
docker compose -f docker-compose.yml -f docker-compose.auth.yml up -d
```

**With authentication enabled:**

- **Identity**: http://localhost:8084 (Authentication server)
- **Default User**: `admin` / `admin`

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
