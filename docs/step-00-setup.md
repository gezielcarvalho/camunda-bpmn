# Step 00: Camunda 8 Environment Setup

Welcome to the Camunda 8 learning journey! This step covers setting up your complete development environment.

## 🎯 **Learning Objectives**

By the end of this step, you will have:

- ✅ A fully functional Camunda 8 development environment
- ✅ Understanding of the core Camunda 8 components
- ✅ Access to Operate and Tasklist web interfaces
- ✅ Zeebe workflow engine ready for BPMN deployment

---

## 🏗️ **Architecture Overview**

Your local Camunda 8 stack includes:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Camunda       │    │     Zeebe        │    │  Elasticsearch  │
│   Modeler       │───▶│  (Workflow       │───▶│   (Data         │
│                 │    │   Engine)        │    │   Storage)      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │                         ▲
                              ▼                         │
┌─────────────────┐    ┌──────────────────┐            │
│    Operate      │    │    Tasklist      │            │
│  (Monitoring)   │◀───┤  (Human Tasks)   │────────────┘
└─────────────────┘    └──────────────────┘
```

### **Components:**

| Component         | Purpose                                      | Port  | Access         |
| ----------------- | -------------------------------------------- | ----- | -------------- |
| **Zeebe**         | Workflow engine that executes BPMN processes | 26500 | gRPC (Modeler) |
| **Operate**       | Monitor workflow instances and troubleshoot  | 8081  | Web UI         |
| **Tasklist**      | Complete human tasks in workflows            | 8082  | Web UI         |
| **Elasticsearch** | Data storage for Operate and Tasklist        | 9200  | REST API       |

---

## 🚀 **Quick Setup**

### **Prerequisites**

- Docker 24+ with Docker Compose
- 4+ GB RAM available
- Ports 26500, 8081, 8082, 9200 free

### **1. Clone and Configure**

```bash
# Navigate to your project
cd camunda-bpmn

# Copy environment configuration
cp .env.example .env

# (Optional) Edit .env to customize passwords/versions
nano .env
```

### **2. Start the Stack**

```bash
# Quick start (recommended)
./start.sh

# OR manual start
docker compose up -d
```

### **3. Verify Services**

```bash
# Check all services are healthy
./health-check.sh

# Expected output:
# ✅ Operate: OK
# ✅ Tasklist: OK
# ✅ Elasticsearch: OK
# ✅ Zeebe gRPC (port 26500): OK
```

---

## 🔐 **Access Your Environment**

### **Web Interfaces**

| Service      | URL                            | Credentials |
| ------------ | ------------------------------ | ----------- |
| **Operate**  | http://localhost:8081/operate  | demo / demo |
| **Tasklist** | http://localhost:8082/tasklist | demo / demo |

### **Development Tools**

| Tool                | Connection            | Notes                     |
| ------------------- | --------------------- | ------------------------- |
| **Camunda Modeler** | localhost:26500       | Download from camunda.com |
| **Elasticsearch**   | http://localhost:9200 | elastic / changeme        |

---

## ✅ **Verification Checklist**

Complete these steps to verify your setup:

### **1. Access Web Interfaces**

- [ ] Navigate to http://localhost:8081/operate
- [ ] Login with `demo` / `demo`
- [ ] See empty dashboard (no processes yet)
- [ ] Navigate to http://localhost:8082/tasklist
- [ ] Login with `demo` / `demo`
- [ ] See empty task list

### **2. Check Zeebe Connection**

```bash
# Test port accessibility
nc -zv localhost 26500
# Should show: Connection succeeded
```

### **3. Verify Elasticsearch**

```bash
# Check cluster status
curl -u elastic:changeme http://localhost:9200
# Should return JSON with cluster information
```

---

## 🛠️ **Common Commands**

```bash
# View service logs
docker compose logs -f zeebe
docker compose logs -f operate
docker compose logs -f tasklist

# Restart services
docker compose restart

# Stop services (keep data)
docker compose down

# Stop and remove all data
docker compose down -v

# Check service status
docker compose ps
```

---

## 🔧 **Troubleshooting**

### **Services Won't Start**

- Check available RAM: `docker system df`
- Verify ports are free: `netstat -tlnp | grep -E "(8081|8082|9200|26500)"`
- Check Docker logs: `docker compose logs`

### **Login Issues**

- **Operate/Tasklist**: Use `demo` / `demo`
- **Elasticsearch**: Use `elastic` / `changeme`
- Clear browser cache if stuck on old login

### **Port 8084 Connection Refused**

- This is normal! Identity service is disabled for development
- Only needed for enterprise SSO features

---

## 📚 **What's Next?**

Once your environment is running:

1. **Step 01**: [Getting Started](step-01-getting-started.md) - Create your first workflow
2. Download [Camunda Modeler](https://camunda.com/download/modeler/)
3. Explore the sample BPMN file in `/bpmn/hello-world.bpmn`

---

## 🆘 **Need Help?**

- Check `CREDENTIALS.md` for all login information
- Review `QUICKSTART.md` for quick commands
- Run `./health-check.sh` to diagnose issues

**Your Camunda 8 development environment is ready! 🎉**
