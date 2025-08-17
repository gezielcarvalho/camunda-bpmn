# 🔐 Camunda 8 Credentials Reference

## Service Access Credentials

### Camunda Services (Local Authentication)

| Service      | URL                            | Username | Password |
| ------------ | ------------------------------ | -------- | -------- |
| **Operate**  | http://localhost:8081/operate  | `demo`   | `demo`   |
| **Tasklist** | http://localhost:8082/tasklist | `demo`   | `demo`   |

### Infrastructure Services

| Service           | URL                   | Username  | Password   |
| ----------------- | --------------------- | --------- | ---------- |
| **Elasticsearch** | http://localhost:9200 | `elastic` | `changeme` |

### Development Tools

| Service             | Connection                   | Authentication |
| ------------------- | ---------------------------- | -------------- |
| **Zeebe gRPC**      | `localhost:26500`            | None required  |
| **Camunda Modeler** | Connect to `localhost:26500` | None required  |

## Quick Test Commands

```bash
# Test Operate
curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/operate
# Should return: 200

# Test Tasklist
curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/tasklist
# Should return: 200

# Test Elasticsearch
curl -u elastic:changeme http://localhost:9200
# Should return cluster info

# Test Zeebe port
nc -zv localhost 26500
# Should return: Connection succeeded
```

## Notes

- These are **development credentials** - change them for production use
- The `demo` user has full access (OWNER role) to all workflow operations
- Elasticsearch credentials are used for direct database access and backups
