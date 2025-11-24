<template>
  <div class="app-container">
    <Header
      @new-diagram="handleNewDiagram"
      @open-diagram="handleOpenDiagram"
      @save-diagram="handleSaveDiagram"
      @deploy="handleDeploy"
      :can-deploy="canDeploy"
    />
    <BpmnModeler
      ref="modelerRef"
      @modeler-ready="onModelerReady"
      @diagram-changed="onDiagramChanged"
    />
    <StatusBar :message="statusMessage" :type="statusType" />
  </div>
</template>

<script setup>
import { ref } from "vue";
import Header from "./components/Header.vue";
import BpmnModeler from "./components/BpmnModeler.vue";
import StatusBar from "./components/StatusBar.vue";
import { deployToZeebe } from "./services/zeebe";

const modelerRef = ref(null);
const statusMessage = ref("Ready");
const statusType = ref("info");
const canDeploy = ref(false);

const onModelerReady = () => {
  setStatus("Modeler ready", "success");
  canDeploy.value = true;
};

const onDiagramChanged = () => {
  setStatus("Diagram modified", "info");
};

const handleNewDiagram = async () => {
  if (confirm("Create a new diagram? Unsaved changes will be lost.")) {
    await modelerRef.value.createNewDiagram();
    setStatus("New diagram created", "success");
  }
};

const handleOpenDiagram = () => {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = ".bpmn,.xml";
  input.onchange = async (e) => {
    const file = e.target.files[0];
    if (file) {
      const text = await file.text();
      await modelerRef.value.openDiagram(text);
      setStatus(`Opened: ${file.name}`, "success");
    }
  };
  input.click();
};

const handleSaveDiagram = async () => {
  try {
    const { xml } = await modelerRef.value.saveDiagram();
    const blob = new Blob([xml], { type: "application/xml" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "diagram.bpmn";
    a.click();
    URL.revokeObjectURL(url);
    setStatus("Diagram saved", "success");
  } catch (error) {
    setStatus(`Save failed: ${error.message}`, "error");
  }
};

const handleDeploy = async () => {
  try {
    setStatus("Deploying to Zeebe...", "info");
    const { xml } = await modelerRef.value.saveDiagram();
    const result = await deployToZeebe(xml);
    setStatus(
      `Deployed successfully! Process: ${
        result.processes[0]?.bpmnProcessId || "Unknown"
      }`,
      "success"
    );
  } catch (error) {
    setStatus(`Deployment failed: ${error.message}`, "error");
  }
};

const setStatus = (message, type = "info") => {
  statusMessage.value = message;
  statusType.value = type;
};
</script>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
}
</style>
