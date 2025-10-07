#!/bin/bash
set -e

echo "🛑 Stopping Manfree Technologies Nextcloud Platform..."

# Ask before creating backup
if [ -f "./auto-backup.sh" ]; then
    echo "💾 Create backup before stopping?"
    read -p "Create backup? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "💾 Creating backup..."
        if ! ./auto-backup.sh; then
            echo "⚠️  Backup creation failed, continuing with shutdown"
        fi
    else
        echo "⏭️  Skipping backup creation"
    fi
fi

# Stop containers
echo "🛑 Stopping containers..."
docker-compose down

echo ""
echo "✅ Nextcloud Platform stopped successfully!"
echo "💾 Backup saved (if created)"
echo "🔧 To start again: ./up.sh"
