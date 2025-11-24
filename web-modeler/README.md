# Camunda Web Modeler

A web-based BPMN modeler for Camunda 8, built with Vue.js and bpmn-js.

## 🎯 Features

- ✅ **Visual BPMN Editor** - Full drag-and-drop BPMN 2.0 modeling
- ✅ **Properties Panel** - Configure elements with Zeebe-specific properties
- ✅ **Deploy to Zeebe** - One-click deployment to your Camunda 8 instance
- ✅ **Save/Load BPMN** - Import and export BPMN files
- ✅ **Zeebe Compatible** - Built with Zeebe moddle extensions
- ✅ **Modern UI** - Clean, responsive interface

## 🚀 Quick Start

### Option 1: Run with Docker (Recommended)

```bash
# From the project root
docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d
```

Access the modeler at: **http://localhost:3000**

### Option 2: Run Locally (Development)

```bash
# Navigate to web-modeler directory
cd web-modeler

# Install dependencies
npm install

# Start development server
npm run dev
```

Access at: **http://localhost:3000**

## 📖 Usage

### Creating a New Diagram

1. Click **"📄 New"** to create a new BPMN diagram
2. Use the palette on the left to add BPMN elements
3. Click elements to configure properties in the right panel
4. Save your diagram with **"💾 Save"**

### Opening an Existing Diagram

1. Click **"📁 Open"**
2. Select a `.bpmn` or `.xml` file from your computer
3. The diagram will load in the editor

### Deploying to Zeebe

1. Create or open a BPMN diagram
2. Ensure your process has:
   - A valid **Process ID** (in properties panel)
   - **Executable** checkbox checked
3. Click **"🚀 Deploy to Zeebe"**
4. Check status in the bottom bar

### Keyboard Shortcuts

- **Ctrl/Cmd + S** - Save diagram
- **Ctrl/Cmd + Z** - Undo
- **Ctrl/Cmd + Y** - Redo
- **Delete** - Remove selected element
- **Space** - Hand tool (pan canvas)

## 🏗️ Architecture

```
┌─────────────────┐
│   Vue.js App    │
├─────────────────┤
│   bpmn-js       │  ← BPMN rendering & editing
├─────────────────┤
│ Properties Panel│  ← Element configuration
├─────────────────┤
│ Zeebe Service   │  ← Deployment API
└────────┬────────┘
         │
         ▼
   ┌──────────┐
   │  Zeebe   │  ← Workflow engine
   └──────────┘
```

## 🔧 Configuration

### Environment Variables

Create `.env` file:

```bash
VITE_ZEEBE_GATEWAY=http://localhost:8080
```

### Zeebe Connection

The modeler connects to Zeebe via REST API. Ensure your Zeebe instance is running and accessible.

**Note**: Current implementation assumes Zeebe REST gateway. For gRPC deployment, you'll need to add a proxy or use zbctl.

## 📦 Building for Production

```bash
# Build the application
npm run build

# Preview production build
npm run preview
```

The build output will be in the `dist/` directory.

## 🐳 Docker Deployment

### Build the Docker image

```bash
cd web-modeler
docker build -t camunda-web-modeler .
```

### Run standalone

```bash
docker run -p 3000:80 \
  -e VITE_ZEEBE_GATEWAY=http://zeebe:8080 \
  camunda-web-modeler
```

### Run with full stack

```bash
# From project root
docker compose -f docker-compose.yml -f docker-compose.modeler.yml up -d
```

## 🛠️ Development

### Project Structure

```
web-modeler/
├── src/
│   ├── components/
│   │   ├── Header.vue          # Top toolbar
│   │   ├── BpmnModeler.vue     # Main modeler component
│   │   └── StatusBar.vue       # Bottom status bar
│   ├── services/
│   │   └── zeebe.js            # Zeebe API integration
│   ├── assets/
│   │   └── main.css            # Global styles
│   ├── App.vue                 # Root component
│   └── main.js                 # Application entry
├── public/                     # Static assets
├── Dockerfile                  # Docker build config
├── nginx.conf                  # Nginx configuration
├── vite.config.js             # Vite build config
└── package.json               # Dependencies
```

### Tech Stack

- **Vue 3** - Frontend framework
- **Vite** - Build tool
- **bpmn-js** - BPMN rendering engine
- **bpmn-js-properties-panel** - Properties configuration
- **zeebe-bpmn-moddle** - Zeebe BPMN extensions
- **Axios** - HTTP client

## 🔮 Future Enhancements

### Planned Features

- [ ] Process instance creation from modeler
- [ ] Template library with common patterns
- [ ] Collaboration features (multi-user)
- [ ] Version history
- [ ] Process validation before deployment
- [ ] Integration with Operate (view deployed processes)
- [ ] Dark mode
- [ ] Mobile responsive design
- [ ] Export to PNG/SVG
- [ ] Process simulation
- [ ] gRPC deployment support
- [ ] Authentication integration

### Contribution Ideas

Want to enhance the modeler? Here are some ideas:

1. **Add process templates** - Pre-built BPMN patterns
2. **Improve deployment** - Add validation before deploy
3. **Add testing** - Unit and E2E tests
4. **Enhance UI** - Better styling, animations
5. **Add shortcuts** - More keyboard shortcuts
6. **Process versioning** - Track diagram versions

## 🐛 Troubleshooting

### Modeler won't load

- Check browser console for errors
- Verify all dependencies installed: `npm install`
- Clear browser cache

### Can't deploy to Zeebe

- Ensure Zeebe is running: `docker compose ps`
- Check Zeebe connection in `.env`
- Verify process is marked as **executable**
- Check process ID is set

### Properties panel not showing

- Refresh the page
- Check for JavaScript errors in console
- Verify bpmn-js-properties-panel is installed

### Diagram won't save

- Check browser permissions for file downloads
- Try a different browser
- Check console for errors

## 📚 Resources

- [bpmn-js Documentation](https://bpmn.io/toolkit/bpmn-js/)
- [Camunda 8 Docs](https://docs.camunda.io/)
- [BPMN 2.0 Specification](https://www.omg.org/spec/BPMN/2.0/)
- [Vue.js Documentation](https://vuejs.org/)

## 📄 License

MIT License - See parent project LICENSE

## 🙏 Acknowledgments

Built with:

- [bpmn-js](https://bpmn.io) by Camunda
- [Vue.js](https://vuejs.org/)
- [Vite](https://vitejs.dev/)

---

**Happy Modeling!** 🚀
