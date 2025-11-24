# Step 02: Create Your First End-to-End Workflow

In this tutorial, you'll create a complete workflow from scratch and simulate an end-to-end business process using Camunda 8.

## 🎯 What You'll Build

A **Customer Order Fulfillment Process** that includes:

- Order creation
- Payment validation
- Inventory check
- Order approval (human task)
- Shipping confirmation
- Order completion

## 📋 Prerequisites

- Camunda 8 stack running (completed [Step 00](step-00-setup.md))
- [Camunda Modeler](https://camunda.com/download/modeler/) installed
- Basic understanding of BPMN (we'll guide you through it)

---

## Part 1: Design the Workflow

### Step 1: Create a New BPMN Diagram

1. **Open Camunda Modeler**
2. Click **File → New File → BPMN Diagram**
3. Click anywhere on the canvas to see the properties panel

### Step 2: Configure the Process

In the **Properties Panel** (right side):

1. **General Tab:**

   - **Id**: `order-fulfillment`
   - **Name**: `Order Fulfillment Process`
   - **Executable**: ✅ Check this box (critical!)

2. **Version Tag**: `1.0`

### Step 3: Build the Process Flow

#### Add Start Event

1. The canvas already has a **Start Event** (circle)
2. Click on it and set properties:
   - **Id**: `StartEvent_OrderReceived`
   - **Name**: `Order Received`

#### Add Service Task: Validate Payment

1. Click the **Start Event**
2. Click the **Append Task** icon (rectangle)
3. Click the **wrench icon** → select **Service Task**
4. Set properties:
   - **Id**: `Task_ValidatePayment`
   - **Name**: `Validate Payment`
   - **Implementation**: `Zeebe service task`
5. In the **Task definition** section:
   - **Type**: `validate-payment`
   - **Retries**: `3`

#### Add Service Task: Check Inventory

1. Click **Task_ValidatePayment**
2. Append another **Service Task**
3. Set properties:
   - **Id**: `Task_CheckInventory`
   - **Name**: `Check Inventory`
   - **Type**: `check-inventory`
   - **Retries**: `3`

#### Add Exclusive Gateway: Stock Available?

1. Click **Task_CheckInventory**
2. Click **Append Gateway** icon (diamond)
3. Select **Exclusive Gateway**
4. Set properties:
   - **Id**: `Gateway_StockCheck`
   - **Name**: `Stock Available?`

#### Add User Task: Approve Order

1. Click **Gateway_StockCheck**
2. Append a **Task** → change to **User Task** (person icon)
3. Set properties:

   - **Id**: `Task_ApproveOrder`
   - **Name**: `Approve Order`
   - **Assignee**: `demo`
   - **Candidate Groups**: `hr-team`

4. **Add a Form** (optional but recommended):
   - In **Forms** section, click **+**
   - Select **Camunda Form**
   - Create a simple form with:
     - **Form ID**: `form-approve-order`
     - Add a text field: `orderNotes`
     - Add a checkbox: `approved`

#### Add Service Task: Process Shipment

1. Click **Task_ApproveOrder**
2. Append **Service Task**
3. Set properties:
   - **Id**: `Task_ProcessShipment`
   - **Name**: `Process Shipment`
   - **Type**: `process-shipment`
   - **Retries**: `3`

#### Add End Event: Order Completed

1. Click **Task_ProcessShipment**
2. Click **Append End Event** (thick circle)
3. Set properties:
   - **Id**: `EndEvent_OrderCompleted`
   - **Name**: `Order Completed`

#### Add Path for Out of Stock

1. Click **Gateway_StockCheck**
2. Append **End Event**
3. Set properties:
   - **Id**: `EndEvent_OutOfStock`
   - **Name**: `Out of Stock`

#### Configure Gateway Conditions

1. **Click the sequence flow** from Gateway to `Task_ApproveOrder`:

   - **Name**: `In Stock`
   - **Condition expression**: `=stockAvailable = true`
   - **Id**: `Flow_InStock`

2. **Click the sequence flow** from Gateway to `EndEvent_OutOfStock`:
   - **Name**: `Out of Stock`
   - **Condition expression**: `=stockAvailable = false`
   - **Id**: `Flow_OutOfStock`

### Step 4: Save Your BPMN File

1. **File → Save As**
2. Save to: `camunda-bpmn/bpmn/order-fulfillment.bpmn`

Your diagram should look like this:

```
[Start] → [Validate Payment] → [Check Inventory] → <Stock Available?>
                                                           ↓ (Yes)
                                                    [Approve Order] → [Process Shipment] → [End]
                                                           ↓ (No)
                                                      [Out of Stock End]
```

---

## Part 2: Deploy the Workflow

### Step 1: Configure Zeebe Connection in Modeler

1. In Camunda Modeler, click the **Deploy** button (rocket icon)
2. Configure connection:

   - **Target**: `Self-Managed`
   - **Cluster endpoint**: `http://localhost:26500`
   - **Authentication**: `None`

3. Click **Deploy**

✅ You should see: **"Deployment successful"**

### Alternative: Deploy via zbctl

```bash
# From your project directory
zbctl --address localhost:26500 deploy bpmn/order-fulfillment.bpmn
```

---

## Part 3: Simulate the Process End-to-End

### Scenario: Complete Order Flow (Happy Path)

#### Step 1: Start a Process Instance

**Option A: Using Camunda Modeler**

1. After deploying, click **Start Instance** (play button)
2. In the **Variables** section, add:

```json
{
  "orderId": "ORD-12345",
  "customerId": "CUST-001",
  "amount": 99.99,
  "productId": "PROD-ABC",
  "quantity": 2
}
```

3. Click **Start**

**Option B: Using zbctl**

```bash
zbctl --address localhost:26500 create instance order-fulfillment \
  --variables '{"orderId":"ORD-12345","customerId":"CUST-001","amount":99.99,"productId":"PROD-ABC","quantity":2}'
```

#### Step 2: Monitor in Operate

1. Open **Operate**: http://localhost:8081/operate
2. Login: `demo` / `demo`
3. Click on **"Order Fulfillment Process"**
4. You'll see your instance running

**What's happening:**

- Process is waiting at **Validate Payment** (service task)
- Since we don't have workers yet, it will show as active

#### Step 3: Create Mock Workers

To simulate the automated tasks, we'll create simple worker scripts.

**Create a simple worker: `workers/payment-worker.js`**

```javascript
// Install: npm install zeebe-node
const { ZBClient } = require("zeebe-node");

const zbc = new ZBClient("localhost:26500", { useTLS: false });

const worker = zbc.createWorker({
  taskType: "validate-payment",
  taskHandler: (job) => {
    console.log("💳 Validating payment for order:", job.variables.orderId);

    // Simulate payment validation
    const paymentValid = job.variables.amount > 0;

    return job.complete({
      paymentValid: paymentValid,
      paymentId: "PAY-" + Date.now(),
    });
  },
});

console.log("✅ Payment validation worker started");
```

**Create inventory worker: `workers/inventory-worker.js`**

```javascript
const { ZBClient } = require("zeebe-node");

const zbc = new ZBClient("localhost:26500", { useTLS: false });

const worker = zbc.createWorker({
  taskType: "check-inventory",
  taskHandler: (job) => {
    console.log("📦 Checking inventory for product:", job.variables.productId);

    // Simulate inventory check (80% in stock)
    const stockAvailable = Math.random() > 0.2;

    return job.complete({
      stockAvailable: stockAvailable,
      stockLevel: Math.floor(Math.random() * 100),
    });
  },
});

console.log("✅ Inventory check worker started");
```

**Create shipment worker: `workers/shipment-worker.js`**

```javascript
const { ZBClient } = require("zeebe-node");

const zbc = new ZBClient("localhost:26500", { useTLS: false });

const worker = zbc.createWorker({
  taskType: "process-shipment",
  taskHandler: (job) => {
    console.log("🚚 Processing shipment for order:", job.variables.orderId);

    return job.complete({
      trackingNumber: "TRK-" + Date.now(),
      estimatedDelivery: "2025-11-28",
    });
  },
});

console.log("✅ Shipment processing worker started");
```

#### Step 4: Run the Workers

**Terminal 1: Payment Worker**

```bash
cd workers
npm install zeebe-node
node payment-worker.js
```

**Terminal 2: Inventory Worker**

```bash
cd workers
node inventory-worker.js
```

**Terminal 3: Shipment Worker**

```bash
cd workers
node shipment-worker.js
```

#### Step 5: Start a New Instance

Now with workers running, start a new instance:

```bash
zbctl --address localhost:26500 create instance order-fulfillment \
  --variables '{"orderId":"ORD-12346","customerId":"CUST-002","amount":149.99,"productId":"PROD-XYZ","quantity":1}'
```

**Watch it flow through:**

1. ✅ Validate Payment (automated by worker)
2. ✅ Check Inventory (automated by worker)
3. 🟡 **Approve Order** (waiting for human input)

#### Step 6: Complete the Human Task

1. Open **Tasklist**: http://localhost:8082/tasklist
2. Login: `demo` / `demo`
3. You'll see **"Approve Order"** task
4. Click on it
5. Fill in the form (if you added one) or just click **Complete Task**

#### Step 7: Watch Completion

1. Go back to **Operate**
2. The process continues to **Process Shipment**
3. Finally reaches **Order Completed**
4. Process instance shows as **Completed** ✅

---

## Part 4: Simulate Different Scenarios

### Scenario 2: Out of Stock Path

Start an instance and modify the inventory worker to return `false`:

**Temporary modification in `inventory-worker.js`:**

```javascript
return job.complete({
  stockAvailable: false, // Force out of stock
  stockLevel: 0,
});
```

**Start instance:**

```bash
zbctl --address localhost:26500 create instance order-fulfillment \
  --variables '{"orderId":"ORD-12347","customerId":"CUST-003","amount":79.99,"productId":"PROD-RARE","quantity":1}'
```

**Result:**

- Process takes the "Out of Stock" path
- Ends at **EndEvent_OutOfStock**
- No approval needed

### Scenario 3: Process with Variables

Start with rich process data:

```bash
zbctl --address localhost:26500 create instance order-fulfillment \
  --variables '{
    "orderId": "ORD-12348",
    "customerId": "CUST-004",
    "customerName": "John Doe",
    "customerEmail": "john@example.com",
    "amount": 299.99,
    "productId": "PROD-PREMIUM",
    "productName": "Premium Widget",
    "quantity": 3,
    "shippingAddress": {
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zip": "10001"
    },
    "priority": "high"
  }'
```

View these variables in:

- **Operate**: See all process variables
- **Tasklist**: Access in the approval task

---

## Part 5: Understanding What Happened

### The Process Flow

```
1. START → Order Received
   Variables: orderId, customerId, amount, productId, quantity

2. SERVICE TASK → Validate Payment
   Worker: validate-payment
   Output: paymentValid, paymentId

3. SERVICE TASK → Check Inventory
   Worker: check-inventory
   Output: stockAvailable, stockLevel

4. GATEWAY → Stock Available?
   Decision: stockAvailable = true/false

5a. USER TASK → Approve Order (if in stock)
    Assigned to: demo
    Manual completion required

6. SERVICE TASK → Process Shipment
   Worker: process-shipment
   Output: trackingNumber, estimatedDelivery

7. END → Order Completed

5b. END → Out of Stock (alternative path)
```

### Key Concepts You've Learned

✅ **BPMN Elements:**

- Start/End Events
- Service Tasks (automated)
- User Tasks (human)
- Exclusive Gateways (decisions)
- Sequence Flows with conditions

✅ **Camunda 8 Architecture:**

- Zeebe workflow engine
- External task pattern (workers)
- Operate for monitoring
- Tasklist for human tasks

✅ **Process Variables:**

- Passing data through the process
- Using variables in gateway conditions
- Workers reading and writing variables

---

## Part 6: Next Steps

### Enhance Your Workflow

1. **Add Error Handling:**

   - Add boundary error events
   - Implement retry logic
   - Create compensation flows

2. **Add Timers:**

   - Timeout for approval task
   - Scheduled payment reminders
   - SLA tracking

3. **Add Parallel Processing:**

   - Send notification while processing shipment
   - Update CRM and inventory simultaneously

4. **Add Message Events:**
   - External payment confirmation
   - Customer cancellation request

### Production Considerations

- **Deploy workers as services** (Docker containers)
- **Add proper logging** and monitoring
- **Implement error handlers** for all service tasks
- **Use real APIs** instead of mock data
- **Add authentication** to workers
- **Scale workers** horizontally for high throughput

---

## 🎯 Summary

You've successfully:

✅ Created a complete BPMN workflow from scratch  
✅ Deployed it to Camunda 8  
✅ Created external task workers in Node.js  
✅ Simulated end-to-end process execution  
✅ Completed human tasks in Tasklist  
✅ Monitored processes in Operate  
✅ Tested different process paths

**Next Tutorial**: [Step 03: Advanced BPMN Patterns](step-03-advanced-patterns.md) _(coming soon)_

---

## 📚 Additional Resources

- [BPMN 2.0 Reference](https://camunda.com/bpmn/)
- [Zeebe Node.js Client Docs](https://www.npmjs.com/package/zeebe-node)
- [Camunda 8 Best Practices](https://docs.camunda.io/docs/components/best-practices/best-practices-overview/)
- [Example Workflows](https://github.com/camunda-community-hub/camunda-8-examples)

---

## 🆘 Troubleshooting

**Workers not picking up tasks?**

- Check connection: `localhost:26500`
- Verify `taskType` matches BPMN definition
- Check worker logs for errors

**Tasks stuck in Operate?**

- Ensure workers are running
- Check for incidents (click on instance)
- Verify service task configuration

**Can't see tasks in Tasklist?**

- Check assignee matches logged-in user
- Verify user task configuration
- Check candidate groups

**Gateway not working?**

- Verify condition expressions syntax
- Check variable names match exactly
- Ensure `stockAvailable` is boolean

---

**Ready to build more complex workflows? Continue to [Step 03: Advanced BPMN Patterns](step-03-advanced-patterns.md)!** 🚀
