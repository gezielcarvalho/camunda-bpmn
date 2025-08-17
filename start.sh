#!/bin/bash

# Camunda 8 Quick Start Script
# This script helps you get the Camunda 8 stack up and running quickly

set -e

echo "🚀 Starting Camunda 8 Stack Setup..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists, if not copy from example
if [ ! -f .env ]; then
    echo "📋 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. You can edit it to customize your setup."
else
    echo "✅ .env file already exists."
fi

# Pull the latest images
echo "🐳 Pulling Docker images..."
docker compose pull

# Start the stack
echo "🚀 Starting Camunda 8 stack..."
docker compose up -d

# Wait a bit for services to start
echo "⏳ Waiting for services to initialize..."
sleep 30

# Check service status
echo "🔍 Checking service status..."
docker compose ps

echo ""
echo "🎉 Camunda 8 stack is starting up!"
echo ""
echo "📊 Access the applications:"
echo "   • Operate:      http://localhost:8081"
echo "   • Tasklist:     http://localhost:8082"  
echo "   • Identity:     http://localhost:8084"
echo "   • Elasticsearch: http://localhost:9200 (user: elastic, pass: changeme)"
echo ""
echo "🔧 Zeebe gRPC endpoint: localhost:26500"
echo ""
echo "⏰ Note: First boot may take 1-2 minutes while services initialize."
echo "📋 Check logs with: docker compose logs -f [service-name]"
echo "🛑 Stop with: docker compose down"
echo "🗑️  Stop and remove data: docker compose down -v"
