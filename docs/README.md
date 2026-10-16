# 📚 Camunda 8 Learning Path

Welcome to the comprehensive Camunda 8 learning journey! This structured path will take you from setup to advanced workflow automation.

## Project documentation

The learning path below is complemented by concise project-governance documents:

- [Project charter](project-charter.md) — portfolio purpose, scope, and boundaries
- [Architecture](architecture.md) — current self-managed stack and modeler shape
- [Delivery and quality](delivery-and-quality.md) — local/dev posture and production prerequisites
- [Decision log](decision-log.md) — traceable operating decisions

## 🎯 **Learning Path Overview**

### **Phase 1: Foundation**

- **[Step 00: Environment Setup](step-00-setup.md)** ⚙️

  - Docker environment setup
  - Service verification
  - Tool installation

- **[Step 01: Getting Started](step-01-getting-started.md)** 🚀
  - First BPMN workflow
  - Camunda Modeler basics
  - Deploy and monitor processes

### **Phase 2: Core Concepts** _(Coming Soon)_

- **Step 02: Advanced BPMN Elements** 🔄

  - Gateways and decision logic
  - Events and timers
  - Sub-processes

- **Step 03: External Task Workers** 🔌
  - Service task implementation
  - External worker clients
  - System integration

### **Phase 3: Production Ready** _(Coming Soon)_

- **Step 04: Forms and User Interface** 📝

  - Camunda Forms
  - Task assignment strategies
  - User interface design

- **Step 05: Error Handling** ⚠️
  - Incident management
  - Retry strategies
  - Compensation flows

### **Phase 4: Advanced Topics** _(Coming Soon)_

- **Step 06: Performance and Scaling** 📈
- **Step 07: Testing Workflows** 🧪
- **Step 08: Production Deployment** 🏭

---

## 🎯 **Prerequisites**

Before starting, ensure you have:

- Docker 24+ with Docker Compose
- 4+ GB available RAM
- Basic understanding of business processes
- Text editor or IDE of choice

---

## 🚀 **Quick Start**

### **1. Complete Environment Setup**

```bash
# Navigate to project root
cd camunda-bpmn

# Start your journey
open docs/step-00-setup.md
```

### **2. Follow the Learning Path**

Each step builds on the previous one:

1. Complete Step 00 (Setup)
2. Verify your environment works
3. Proceed to Step 01 (Getting Started)
4. Continue sequentially through each step

### **3. Hands-On Learning**

- Follow each tutorial completely
- Experiment with variations
- Save your work in the `bpmn/` folder
- Document your learnings

---

## 📋 **Learning Objectives**

By completing this learning path, you will:

### **Technical Skills**

- ✅ Model business processes in BPMN 2.0
- ✅ Deploy and manage workflows in Camunda 8
- ✅ Build external task workers
- ✅ Handle errors and incidents
- ✅ Integrate with external systems
- ✅ Monitor and optimize processes

### **Conceptual Understanding**

- ✅ Workflow automation principles
- ✅ Event-driven architectures
- ✅ Human task management
- ✅ Process orchestration vs choreography
- ✅ Microservices integration patterns

---

## 🎯 **Success Milestones**

Track your progress:

- [ ] **Setup Complete**: Environment running, all services accessible
- [ ] **First Workflow**: Created, deployed, and executed a BPMN process
- [ ] **Task Management**: Completed human tasks in Tasklist
- [ ] **Monitoring**: Used Operate to track process instances
- [ ] **Integration**: Built external task workers
- [ ] **Error Handling**: Managed incidents and retries
- [ ] **Production Ready**: Deployed scalable workflow solution

---

## 🛠️ **Tools and Resources**

### **Required Tools**

- **Camunda Modeler**: BPMN design and deployment
- **Docker**: Container orchestration
- **Web Browser**: Access Operate and Tasklist

### **Optional Tools**

- **zbctl**: Command-line Zeebe client
- **Postman**: API testing
- **IDE**: Code development for workers

### **Documentation Links**

- [Camunda 8 Documentation](https://docs.camunda.io/)
- [BPMN 2.0 Reference](https://camunda.com/bpmn/)
- [Zeebe Documentation](https://docs.camunda.io/docs/components/zeebe/zeebe-overview/)

---

## 🤝 **Learning Tips**

### **Best Practices**

1. **Complete each step fully** before moving on
2. **Experiment** with variations and extensions
3. **Save your work** in organized folders
4. **Document challenges** and solutions
5. **Join the community** for support and discussion

### **Common Pitfalls**

- Skipping environment verification
- Not understanding BPMN semantics
- Ignoring error handling
- Over-complicating initial processes

### **When You're Stuck**

1. Review the troubleshooting sections
2. Check service logs: `docker compose logs -f [service]`
3. Verify connections and credentials
4. Restart services if needed: `docker compose restart`

---

## 📈 **Progress Tracking**

Keep track of your learning:

```markdown
## My Learning Progress

- [x] Step 00: Setup - Completed ✅
- [ ] Step 01: Getting Started - In Progress 🔄
- [ ] Step 02: Advanced BPMN - Not Started ⏳
- [ ] Step 03: External Workers - Not Started ⏳

### Notes:

- Date started: ****\_\_\_****
- Challenges faced: ****\_\_\_****
- Key learnings: ****\_\_\_****
```

---

## 🆘 **Support**

### **Quick References**

- [CREDENTIALS.md](../CREDENTIALS.md): All login information
- [QUICKSTART.md](../QUICKSTART.md): Quick commands
- [health-check.sh](../health-check.sh): Verify environment

### **Troubleshooting**

- Check Docker status: `docker compose ps`
- View service logs: `docker compose logs -f [service]`
- Restart environment: `docker compose restart`

---

**Ready to become a Camunda 8 expert? Start with [Step 00: Setup](step-00-setup.md)!** 🚀
