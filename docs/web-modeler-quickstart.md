# 🎨 Web Modeler Quick Start

## Installation & Setup

### Option 1: Docker (Easiest)

```bash
# From project root
docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d
```

**Access**: http://localhost:3000

### Option 2: Local Development

```bash
# Navigate to web-modeler
cd web-modeler

# Install dependencies
npm install

# Start dev server
npm run dev
```

**Access**: http://localhost:3000

## First Steps

1. **Open the modeler** at http://localhost:3000
2. **Create a diagram** - Click "📄 New"
3. **Design your process**:
   - Use the left palette to add elements
   - Click elements to configure in right panel
   - Set Process ID and mark as "Executable"
4. **Deploy** - Click "🚀 Deploy to Zeebe"
5. **Monitor** - Check in Operate (http://localhost:8081)

## Key Features

- ✅ Drag-and-drop BPMN editor
- ✅ Properties panel with Zeebe extensions
- ✅ One-click deployment
- ✅ Save/Load BPMN files
- ✅ Built on bpmn-js (same as Camunda Modeler)

## What's Different from Camunda Modeler?

| Feature       | Web Modeler        | Desktop Modeler    |
| ------------- | ------------------ | ------------------ |
| Access        | Web browser        | Desktop app        |
| Installation  | Docker/npm         | Download installer |
| Collaboration | Easy (URL sharing) | File-based         |
| Updates       | Instant            | Manual download    |
| Customization | Full control       | Limited            |
| Features      | Basic → evolving   | Full-featured      |

## Evolution Path

This is a **proof-of-concept** that can grow:

### Phase 1 (Current) ✅

- Basic BPMN editing
- Properties configuration
- Deployment to Zeebe

### Phase 2 (Coming Soon)

- Process templates
- Better validation
- Process instance creation
- Dark mode

### Phase 3 (Future)

- Multi-user collaboration
- Version control
- Process simulation
- Integration with Operate

## See Full Documentation

Read **[web-modeler/README.md](../web-modeler/README.md)** for:

- Architecture details
- Development guide
- API reference
- Troubleshooting

---

**Ready to start?** Run the modeler and create your first diagram! 🚀
