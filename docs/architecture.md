# Architecture

## Current shape

```text
BPMN files / Vue web modeler / CLI clients
                 |
                 v
          Zeebe workflow engine
                 |
                 v
          Elasticsearch
            ^          ^
            |          |
       Operate      Tasklist

Optional: Identity overlay and reverse-proxy examples
```

The default Compose topology is intentionally compact: a single Zeebe broker exports workflow information to Elasticsearch, while Operate and Tasklist provide local user interfaces. The Vue modeler uses bpmn-js and Zeebe BPMN extensions for in-browser authoring. Identity is optional rather than enabled by default.

## Operational boundary

This architecture targets local development and learning. Single-node topology, local authentication, development credentials, exposed ports, and local volumes are not a production deployment design. See the root README production-hardening checklist for detailed follow-up guidance.
