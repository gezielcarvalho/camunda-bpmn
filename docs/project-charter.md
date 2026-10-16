# Project charter

## Purpose

Provide a reproducible local Camunda 8 environment and a practical learning path for BPMN modeling, deployment, task management, workflow observation, and a browser-based modeler.

## Portfolio value

This repository demonstrates workflow/BPMN engineering breadth across Docker Compose, Camunda 8/Zeebe, Elasticsearch, Vue, bpmn-js, health checks, backup guidance, and developer documentation.

## Current scope

- Local or staging-oriented single-node Camunda 8 stack.
- BPMN learning guides and a sample workflow.
- Optional Vue-based BPMN modeler that can deploy against the local Zeebe environment.
- Health-check, bootstrap, backup, and reverse-proxy reference assets.

## Outside current scope

- A production workflow platform, high availability, or a supported operational service.
- Real business-process workers, customer workflows, managed identity, and a formal deployment pipeline.
- Any use of defaults as production credentials or internet-exposed configuration.
