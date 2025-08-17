#!/bin/bash

# Health check script for Camunda 8 services
# This script checks if all services are healthy and accessible

echo "🔍 Checking Camunda 8 Services Health..."
echo ""

# Function to check HTTP endpoint
check_http() {
    local name=$1
    local url=$2
    local expected_code=${3:-200}
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_code"; then
        echo "✅ $name: OK"
    else
        echo "❌ $name: Not accessible"
    fi
}

# Function to check Zeebe gRPC port
check_zeebe() {
    if nc -zv localhost 26500 >/dev/null 2>&1; then
        echo "✅ Zeebe gRPC (port 26500): OK"
    else
        echo "❌ Zeebe gRPC (port 26500): Not accessible"
    fi
}

# Check all services
check_http "Operate" "http://localhost:8081/operate"
check_http "Tasklist" "http://localhost:8082/tasklist" 
check_http "Elasticsearch" "http://localhost:9200" "401"  # 401 because auth required
check_zeebe

echo ""
echo "📊 Container Status:"
docker compose ps

echo ""
echo "💡 If services show as unhealthy, wait a few minutes and try again."
echo "📋 Check logs with: docker compose logs -f [service-name]"
