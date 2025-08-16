#!/bin/bash

# Dengue Bot Docker Build and Run Script

echo "🐳 Building Dengue Bot Docker Image..."
docker build -t dengue-bot:latest .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo ""
    echo "🚀 Starting Dengue Bot API container..."
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo ""
        echo "📋 Container Status:"
        docker-compose ps
        echo ""
        echo "🌐 API Endpoints:"
        echo "- Health Check: http://localhost:8000/health"
        echo "- API Info: http://localhost:8000/"
        echo "- Ask Questions: POST http://localhost:8000/ask"
        echo ""
        echo "📊 To view logs: docker-compose logs -f"
        echo "🛑 To stop: docker-compose down"
    else
        echo "❌ Failed to start container"
        exit 1
    fi
else
    echo "❌ Failed to build Docker image"
    exit 1
fi
