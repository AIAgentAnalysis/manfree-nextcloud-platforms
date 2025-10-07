#!/bin/bash
set -e

echo "🚀 Starting Manfree Technologies Nextcloud Platform..."

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "✏️  Please edit .env file with your configuration"
    exit 1
fi

# Ask before restoring backup
if [ -f "./auto-restore.sh" ] && [ -d "./backup" ] && [ "$(ls -A ./backup/*.tar.gz 2>/dev/null)" ]; then
    echo "📦 Backup found. Restore it?"
    read -p "Restore backup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔄 Restoring backup..."
        if ! ./auto-restore.sh; then
            echo "❌ Backup restore failed"
            exit 1
        fi
    else
        echo "⏭️  Skipping backup restore"
    fi
fi

# Pull required images first
echo "📥 Pulling Docker images..."
if ! docker pull nextcloud:latest || ! docker pull mariadb:10.6 || ! docker pull redis:alpine; then
    echo "❌ Failed to pull Docker images"
    exit 1
fi

# Start containers (build only if needed)
echo "🚀 Starting containers..."
if ! docker-compose up -d; then
    echo "❌ Failed to start containers"
    docker-compose logs --tail=20
    exit 1
fi

# Wait for services to be ready
echo "⏳ Waiting for services to start (30 seconds)..."
sleep 30

# Get IP address
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ Nextcloud Platform started successfully!"
echo ""
echo "🌐 Access Points:"
echo "   Local:    http://localhost:8090"
echo "   LAN:      http://$IP:8090"
echo ""
echo "👤 Admin Credentials (from .env):"
echo "   Username: admin"
echo "   Password: Check .env file"
echo ""
echo "📊 Container Status:"
docker-compose ps
echo ""
echo "💡 First-time setup will take 2-3 minutes to initialize database"
echo "🔧 To stop: ./down.sh"
