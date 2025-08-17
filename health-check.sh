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

# Function to check Zeebe gRPC
check_zeebe() {
    if docker run --rm --network host camunda/zbctl:8.6.3 --address localhost:26500 status > /dev/null 2>&1; then
        echo "✅ Zeebe gRPC: OK"
    else
        echo "❌ Zeebe gRPC: Not accessible"
    fi
}

# Check all services
check_http "Operate" "http://localhost:8081/actuator/health"
check_http "Tasklist" "http://localhost:8082/actuator/health" 
check_http "Identity" "http://localhost:8084/auth/realms/camunda-platform/.well-known/openid_configuration"
check_http "Elasticsearch" "http://localhost:9200" "401"  # 401 because auth required
check_zeebe

echo ""
echo "📊 Container Status:"
docker compose ps

echo ""
echo "💡 If services show as unhealthy, wait a few minutes and try again."
echo "📋 Check logs with: docker compose logs -f [service-name]"
