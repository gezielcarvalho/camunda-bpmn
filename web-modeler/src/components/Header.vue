<template>
  <header class="header">
    <div class="logo">
      <h1>🔧 Camunda Web Modeler</h1>
    </div>
    <nav class="toolbar">
      <button
        @click="$emit('new-diagram')"
        class="btn btn-primary"
        title="New Diagram"
      >
        📄 New
      </button>
      <button
        @click="$emit('open-diagram')"
        class="btn btn-secondary"
        title="Open BPMN File"
      >
        📁 Open
      </button>
      <button
        @click="$emit('save-diagram')"
        class="btn btn-secondary"
        title="Save BPMN File"
      >
        💾 Save
      </button>
      <div class="separator"></div>
      <button
        @click="$emit('deploy')"
        class="btn btn-deploy"
        :disabled="!canDeploy"
        title="Deploy to Zeebe"
      >
        🚀 Deploy to Zeebe
      </button>
    </nav>
  </header>
</template>

<script setup>
defineProps({
  canDeploy: {
    type: Boolean,
    default: false,
  },
});

defineEmits(["new-diagram", "open-diagram", "save-diagram", "deploy"]);
</script>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.logo h1 {
  font-size: 20px;
  font-weight: 600;
  margin: 0;
}

.toolbar {
  display: flex;
  gap: 8px;
  align-items: center;
}

.separator {
  width: 1px;
  height: 30px;
  background: rgba(255, 255, 255, 0.3);
  margin: 0 8px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 6px;
}

.btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn:active:not(:disabled) {
  transform: translateY(0);
}

.btn-primary {
  background: white;
  color: #667eea;
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.btn-deploy {
  background: #10b981;
  color: white;
  font-weight: 600;
}

.btn-deploy:hover:not(:disabled) {
  background: #059669;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
