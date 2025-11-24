import axios from "axios";

const ZEEBE_GATEWAY =
  import.meta.env.VITE_ZEEBE_GATEWAY || "http://localhost:8080";

/**
 * Deploy BPMN diagram to Zeebe
 * @param {string} xml - BPMN XML content
 * @returns {Promise<Object>} Deployment result
 */
export async function deployToZeebe(xml) {
  try {
    // Create a FormData object to send the BPMN file
    const formData = new FormData();
    const blob = new Blob([xml], { type: "application/xml" });
    formData.append("file", blob, "diagram.bpmn");

    // Deploy via Zeebe REST API (if available) or use grpc-gateway
    const response = await axios.post(
      `${ZEEBE_GATEWAY}/v1/deployments`,
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      }
    );

    return response.data;
  } catch (error) {
    console.error("Deployment error:", error);

    // Fallback: Try alternative deployment method
    if (error.response?.status === 404) {
      throw new Error(
        "Zeebe gateway not available. Make sure Zeebe is running on localhost:26500"
      );
    }

    throw new Error(
      error.response?.data?.message || error.message || "Deployment failed"
    );
  }
}

/**
 * Create a process instance
 * @param {string} processId - BPMN process ID
 * @param {Object} variables - Process variables
 * @returns {Promise<Object>} Instance creation result
 */
export async function createInstance(processId, variables = {}) {
  try {
    const response = await axios.post(`${ZEEBE_GATEWAY}/v1/process-instances`, {
      bpmnProcessId: processId,
      variables,
    });

    return response.data;
  } catch (error) {
    console.error("Instance creation error:", error);
    throw new Error(
      error.response?.data?.message ||
        error.message ||
        "Failed to create instance"
    );
  }
}
