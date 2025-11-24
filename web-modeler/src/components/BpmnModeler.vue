<template>
  <div class="modeler-container">
    <div ref="canvasRef" class="bpmn-canvas"></div>
    <div ref="propertiesRef" class="properties-panel"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import BpmnModeler from "bpmn-js/lib/Modeler";
import {
  BpmnPropertiesPanelModule,
  BpmnPropertiesProviderModule,
} from "bpmn-js-properties-panel";
import ZeebeModdle from "zeebe-bpmn-moddle/resources/zeebe";

// Import BPMN.js styles
import "bpmn-js/dist/assets/diagram-js.css";
import "bpmn-js/dist/assets/bpmn-font/css/bpmn-embedded.css";
import "bpmn-js-properties-panel/dist/assets/properties-panel.css";

const emit = defineEmits(["modeler-ready", "diagram-changed"]);

const canvasRef = ref(null);
const propertiesRef = ref(null);
let modeler = null;

const defaultDiagram = `<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" 
                  xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" 
                  xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" 
                  xmlns:zeebe="http://camunda.org/schema/zeebe/1.0"
                  xmlns:modeler="http://camunda.org/schema/modeler/1.0"
                  id="Definitions_1" 
                  targetNamespace="http://bpmn.io/schema/bpmn"
                  exporter="Camunda Web Modeler" 
                  exporterVersion="1.0.0"
                  modeler:executionPlatform="Camunda Cloud"
                  modeler:executionPlatformVersion="8.6.0">
  <bpmn:process id="Process_1" name="New Process" isExecutable="true">
    <bpmn:startEvent id="StartEvent_1" name="Start">
      <bpmn:outgoing>Flow_1</bpmn:outgoing>
    </bpmn:startEvent>
    <bpmn:sequenceFlow id="Flow_1" sourceRef="StartEvent_1" targetRef="Activity_1" />
    <bpmn:endEvent id="EndEvent_1" name="End">
      <bpmn:incoming>Flow_2</bpmn:incoming>
    </bpmn:endEvent>
    <bpmn:sequenceFlow id="Flow_2" sourceRef="Activity_1" targetRef="EndEvent_1" />
    <bpmn:userTask id="Activity_1" name="Do Something">
      <bpmn:incoming>Flow_1</bpmn:incoming>
      <bpmn:outgoing>Flow_2</bpmn:outgoing>
    </bpmn:userTask>
  </bpmn:process>
  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_1">
      <bpmndi:BPMNShape id="StartEvent_1_di" bpmnElement="StartEvent_1">
        <dc:Bounds x="179" y="99" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="185" y="142" width="24" height="14" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Activity_1_di" bpmnElement="Activity_1">
        <dc:Bounds x="270" y="77" width="100" height="80" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="EndEvent_1_di" bpmnElement="EndEvent_1">
        <dc:Bounds x="432" y="99" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="440" y="142" width="20" height="14" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Flow_1_di" bpmnElement="Flow_1">
        <di:waypoint x="215" y="117" />
        <di:waypoint x="270" y="117" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Flow_2_di" bpmnElement="Flow_2">
        <di:waypoint x="370" y="117" />
        <di:waypoint x="432" y="117" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</bpmn:definitions>`;

onMounted(async () => {
  modeler = new BpmnModeler({
    container: canvasRef.value,
    propertiesPanel: {
      parent: propertiesRef.value,
    },
    additionalModules: [
      BpmnPropertiesPanelModule,
      BpmnPropertiesProviderModule,
    ],
    moddleExtensions: {
      zeebe: ZeebeModdle,
    },
    keyboard: {
      bindTo: document,
    },
  });

  // Listen to diagram changes
  modeler.on("commandStack.changed", () => {
    emit("diagram-changed");
  });

  await createNewDiagram();
  emit("modeler-ready");
});

onBeforeUnmount(() => {
  if (modeler) {
    modeler.destroy();
  }
});

const createNewDiagram = async () => {
  try {
    await modeler.importXML(defaultDiagram);
    const canvas = modeler.get("canvas");
    canvas.zoom("fit-viewport");
  } catch (err) {
    console.error("Error creating diagram:", err);
  }
};

const openDiagram = async (xml) => {
  try {
    await modeler.importXML(xml);
    const canvas = modeler.get("canvas");
    canvas.zoom("fit-viewport");
  } catch (err) {
    console.error("Error opening diagram:", err);
    throw err;
  }
};

const saveDiagram = async () => {
  try {
    const { xml } = await modeler.saveXML({ format: true });
    return { xml };
  } catch (err) {
    console.error("Error saving diagram:", err);
    throw err;
  }
};

// Expose methods to parent
defineExpose({
  createNewDiagram,
  openDiagram,
  saveDiagram,
});
</script>

<style scoped>
.modeler-container {
  display: flex;
  flex: 1;
  overflow: hidden;
  background: #fafafa;
}

.bpmn-canvas {
  flex: 1;
  height: 100%;
  background: white;
}

.properties-panel {
  width: 300px;
  height: 100%;
  overflow-y: auto;
  background: #f8f8f8;
  border-left: 1px solid #ddd;
}

:deep(.djs-palette) {
  background: white;
  border-right: 1px solid #ddd;
}

:deep(.djs-context-pad) {
  background: white;
}
</style>
