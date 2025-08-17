#!/bin/bash

# Bootstrap script for initial setup
# This can be used to pre-configure Camunda 8 services

echo "🔧 Running Camunda 8 bootstrap initialization..."

# Wait for Elasticsearch to be ready
echo "⏳ Waiting for Elasticsearch to be ready..."
until curl -s -u elastic:changeme http://localhost:9200/_cluster/health | grep -q '"status":"green\|yellow"'; do
  echo "Waiting for Elasticsearch..."
  sleep 5
done

echo "✅ Elasticsearch is ready!"

# Setup Elasticsearch snapshot repository
echo "📋 Setting up Elasticsearch backup repository..."
curl -s -u elastic:changeme -X PUT "http://localhost:9200/_snapshot/es_local" \
  -H 'Content-Type: application/json' \
  -d '{
    "type": "fs",
    "settings": {
      "location": "/usr/share/elasticsearch/backup",
      "compress": true
    }
  }' > /dev/null

echo "✅ Backup repository configured!"

# Wait for Zeebe to be ready
echo "⏳ Waiting for Zeebe to be ready..."
until docker run --rm --network host camunda/zbctl:8.6.3 --address localhost:26500 status > /dev/null 2>&1; do
  echo "Waiting for Zeebe..."
  sleep 5
done

echo "✅ Zeebe is ready!"

# Deploy sample process if it exists
if [ -f "/bpmn/hello-world.bpmn" ]; then
  echo "🚀 Deploying sample process..."
  docker run --rm -v "$(pwd)/bpmn:/bpmn" --network host camunda/zbctl:8.6.3 \
    --address localhost:26500 deploy /bpmn/hello-world.bpmn
  echo "✅ Sample process deployed!"
fi

echo "🎉 Bootstrap completed successfully!"
