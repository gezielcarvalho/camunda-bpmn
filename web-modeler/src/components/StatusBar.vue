<template>
  <div class="status-bar" :class="`status-${type}`">
    <span class="status-icon">{{ icon }}</span>
    <span class="status-message">{{ message }}</span>
  </div>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
  message: {
    type: String,
    default: "Ready",
  },
  type: {
    type: String,
    default: "info",
    validator: (value) =>
      ["info", "success", "error", "warning"].includes(value),
  },
});

const icon = computed(() => {
  const icons = {
    info: "ℹ️",
    success: "✅",
    error: "❌",
    warning: "⚠️",
  };
  return icons[props.type];
});
</script>

<style scoped>
.status-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 20px;
  font-size: 13px;
  border-top: 1px solid #ddd;
  background: #f5f5f5;
}

.status-icon {
  font-size: 14px;
}

.status-message {
  flex: 1;
}

.status-info {
  background: #e3f2fd;
  color: #1976d2;
}

.status-success {
  background: #e8f5e9;
  color: #2e7d32;
}

.status-error {
  background: #ffebee;
  color: #c62828;
}

.status-warning {
  background: #fff3e0;
  color: #ef6c00;
}
</style>
