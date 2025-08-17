# Step 01: Getting Started with BPMN Workflows

Now that your Camunda 8 environment is running, let's create and deploy your first workflow!

## 🎯 **Learning Objectives**

By the end of this step, you will:

- ✅ Understand basic BPMN concepts
- ✅ Create a simple workflow in Camunda Modeler
- ✅ Deploy a process to Zeebe
- ✅ Start process instances
- ✅ Monitor workflows in Operate
- ✅ Complete human tasks in Tasklist

---

## 📋 **Prerequisites**

- ✅ Completed [Step 00: Setup](step-00-setup.md)
- ✅ Camunda 8 environment running
- ✅ Access to Operate and Tasklist

---

## 🔧 **Install Camunda Modeler**

### **Download and Install**

1. Visit: https://camunda.com/download/modeler/
2. Download for your operating system
3. Install and launch Camunda Modeler

### **Configure Connection to Zeebe**

1. Open Camunda Modeler
2. Click **"Deploy"** button or go to **Deploy → Configure**
3. Set connection details:
   - **Endpoint**: `localhost:26500`
   - **Authentication**: None (leave unchecked)
4. Click **"Apply"** to save

---

## 🏗️ **Your First BPMN Process**

### **Understanding BPMN Basics**

**BPMN (Business Process Model and Notation)** is a graphical standard for modeling business processes.

**Key Elements:**

- **Start Event** ⭕ - Where the process begins
- **Tasks** 📋 - Work to be performed
- **End Event** 🔴 - Where the process completes
- **Sequence Flows** ➡️ - Process flow direction

### **Create a Simple Process**

Let's create a "Welcome New Employee" process:

1. **Open Camunda Modeler**
2. **Create New BPMN Diagram**
3. **Build the Process:**

```
⭕ Start Event → 📋 Create User Account → 📋 Send Welcome Email → 🔴 End Event
```

### **Step-by-Step Instructions:**

#### **1. Create Start Event**

- Already present by default
- **Properties Panel** → **General** → **Name**: "Employee Onboarding Started"

#### **2. Add First Task**

- Drag **Task** from palette
- Connect Start Event to Task
- **Properties Panel**:
  - **Name**: "Create User Account"
  - **Type**: Service Task
  - **Implementation**: Job type = `create-account`

#### **3. Add Second Task**

- Drag another **Task**
- Connect first task to second task
- **Properties Panel**:
  - **Name**: "Send Welcome Email"
  - **Type**: User Task
  - **Assignment**: Assignee = `hr-team`

#### **4. Add End Event**

- Drag **End Event** from palette
- Connect second task to End Event
- **Name**: "Employee Onboarded"

#### **5. Set Process Properties**

- Click on empty canvas (process level)
- **Properties Panel** → **General**:
  - **Name**: "Employee Onboarding"
  - **Process ID**: `employee-onboarding`
  - **Executable**: ✅ checked

---

## 🚀 **Deploy Your Process**

### **1. Save Your Model**

```bash
# Save to your project's bpmn folder
File → Save As → /path/to/camunda-bpmn/bpmn/employee-onboarding.bpmn
```

### **2. Deploy to Zeebe**

1. Click **"Deploy"** button in Camunda Modeler
2. Verify endpoint: `localhost:26500`
3. Click **"Deploy"**
4. Success message should appear

### **3. Verify Deployment**

```bash
# Check if process is deployed (optional with zbctl)
# First install zbctl if desired:
# wget https://github.com/camunda/zeebe/releases/download/8.6.3/zbctl
# chmod +x zbctl && sudo mv zbctl /usr/local/bin/

# Check deployment (if zbctl installed)
# zbctl --address localhost:26500 list deployments
```

---

## ▶️ **Start Process Instances**

### **Method 1: From Camunda Modeler**

1. After deploying, click **"Start Instance"** button
2. **Variables** (optional): `{"employeeName": "John Doe", "department": "Engineering"}`
3. Click **"Start"**
4. Repeat 2-3 times to create multiple instances

### **Method 2: From Operate**

1. Open http://localhost:8081/operate
2. Login: `demo` / `demo`
3. Click on your process **"Employee Onboarding"**
4. Click **"Start Instance"**
5. Add variables (JSON):

```json
{
  "employeeName": "Jane Smith",
  "department": "Marketing",
  "email": "jane.smith@company.com"
}
```

---

## 📊 **Monitor in Operate**

### **Process Instances View**

1. **Navigate**: http://localhost:8081/operate
2. **Login**: demo / demo
3. **Explore**:
   - **Processes**: See your deployed process
   - **Instances**: View running/completed instances
   - **Incidents**: Any errors or issues

### **Instance Details**

- Click on any instance to see:
  - **Process flow** with current position
  - **Variables** and their values
  - **Activity history**
  - **Incidents** if any errors occurred

### **What You'll See**

- Instances will be **stuck** at "Send Welcome Email" (User Task)
- This is expected! User tasks need human interaction

---

## ✅ **Complete Tasks in Tasklist**

### **Access Tasklist**

1. **Navigate**: http://localhost:8082/tasklist
2. **Login**: demo / demo

### **Complete User Tasks**

1. **Task List**: See "Send Welcome Email" tasks
2. **Click** on a task to open it
3. **Task Details**:
   - View process variables (employeeName, department)
   - Add completion variables if needed
4. **Complete Task**: Click "Complete" button

### **Verify Completion**

- Return to **Operate**
- Instance should now be **completed**
- End event should be highlighted

---

## 🔄 **Process Lifecycle**

Your process follows this lifecycle:

```
1. DEPLOY → Process available in Zeebe
2. START → Instance created and begins execution
3. EXECUTE → Automatic tasks run immediately
4. WAIT → User tasks wait for human interaction
5. COMPLETE → Task completed in Tasklist
6. FINISH → Process reaches end event
```

---

## 🧪 **Experiment and Learn**

### **Try These Variations:**

#### **1. Add More Variables**

Start instances with different data:

```json
{
  "employeeName": "Alice Johnson",
  "department": "Sales",
  "startDate": "2025-08-20",
  "manager": "Bob Wilson"
}
```

#### **2. Create Multiple Instances**

- Start 5-10 instances with different employee data
- Complete some tasks, leave others pending
- Observe the dashboard statistics

#### **3. Intentional Errors**

- Start an instance with invalid data
- See how incidents appear in Operate
- Learn about error handling

---

## 📚 **Key Concepts Learned**

### **BPMN Elements**

- **Start/End Events**: Process boundaries
- **Service Tasks**: Automated work (external systems)
- **User Tasks**: Human work requiring interaction
- **Sequence Flows**: Process execution order

### **Camunda 8 Workflow**

- **Model** → **Deploy** → **Start** → **Monitor** → **Complete**
- **Zeebe**: Executes the workflow logic
- **Operate**: Monitoring and troubleshooting
- **Tasklist**: Human task management

### **Process Variables**

- Carry data through the process
- Available to all tasks
- Can be modified during execution

---

## 🎯 **Success Criteria**

You've successfully completed Step 01 if you can:

- [ ] Create a BPMN process in Camunda Modeler
- [ ] Deploy the process to Zeebe
- [ ] Start process instances with variables
- [ ] Monitor instances in Operate
- [ ] Complete user tasks in Tasklist
- [ ] See completed instances in Operate

---

## 🔗 **What's Next?**

Ready for more advanced concepts?

1. **Step 02**: Advanced BPMN Elements (Gateways, Events, Sub-processes)
2. **Step 03**: External Task Workers and Service Integration
3. **Step 04**: Process Variables and Forms
4. **Step 05**: Error Handling and Incidents

---

## 🆘 **Troubleshooting**

### **Deployment Issues**

- **Check Zeebe connection**: `nc -zv localhost 26500`
- **Verify process ID**: Must be unique and valid
- **Check for BPMN errors**: Red indicators in Modeler

### **Tasks Not Appearing**

- **Check task type**: User tasks appear in Tasklist
- **Verify assignee**: Tasks assigned to users/groups
- **Refresh Tasklist**: Sometimes takes a few seconds

### **Process Stuck**

- **Check Operate**: Look for incidents (red indicators)
- **Review logs**: `docker compose logs -f zeebe`
- **Validate BPMN**: Ensure proper sequence flows

**Congratulations! You've created your first Camunda 8 workflow! 🎉**
