#!/bin/bash
set -e

# Error handling
trap 'echo "❌ Restore failed at line $LINENO"; exit 1' ERR

# Variables
PROJECT_NAME="manfree-nextcloud-platforms"
VOLUME_PREFIX="${PROJECT_NAME}_"
BACKUP_DIR="./backup"

echo "🔄 Nextcloud Backup Restore"

# Find latest backup
if ! LATEST_BACKUP=$(find "${BACKUP_DIR}" -name "*_nextcloud_data.tar.gz" -type f -exec stat -c '%Y %n' {} + 2>/dev/null | \
    sort -rn | head -1 | cut -d' ' -f2- | sed 's/_nextcloud_data.tar.gz//'); then
    echo "❌ Error searching for backups"
    exit 1
fi

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backups found in ${BACKUP_DIR}/"
    exit 1
fi

BACKUP_NAME=$(basename "$LATEST_BACKUP")
echo "📦 Found backup: ${BACKUP_NAME}"
echo ""

# Confirm restore
read -p "⚠️  This will replace current data. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 0
fi

# Stop containers if running
echo "🛑 Stopping containers..."
docker-compose down 2>/dev/null || true

# Remove existing volumes
echo "🗑️  Removing existing volumes..."
docker volume rm "${VOLUME_PREFIX}nextcloud_data" 2>/dev/null || true
docker volume rm "${VOLUME_PREFIX}nextcloud_files" 2>/dev/null || true
docker volume rm "${VOLUME_PREFIX}nextcloud_config" 2>/dev/null || true
docker volume rm "${VOLUME_PREFIX}mariadb_data" 2>/dev/null || true

# Create new volumes
echo "📦 Creating new volumes..."
docker volume create "${VOLUME_PREFIX}nextcloud_data"
docker volume create "${VOLUME_PREFIX}nextcloud_files"
docker volume create "${VOLUME_PREFIX}nextcloud_config"
docker volume create "${VOLUME_PREFIX}mariadb_data"

# Restore function with error handling
restore_volume() {
    local volume_name="$1"
    local backup_file="$2"
    local description="$3"
    
    echo "$description"
    if ! docker run --rm \
        -v "${VOLUME_PREFIX}${volume_name}":/data \
        -v "$(pwd)/${BACKUP_DIR}:/backup" \
        alpine tar xzf "/backup/${backup_file}" -C /data; then
        echo "❌ Failed to restore ${volume_name}"
        exit 1
    fi
}

# Restore all volumes
restore_volume "nextcloud_data" "${BACKUP_NAME}_nextcloud_data.tar.gz" "📦 Restoring Nextcloud data..."
restore_volume "nextcloud_files" "${BACKUP_NAME}_nextcloud_files.tar.gz" "📁 Restoring user files..."
restore_volume "nextcloud_config" "${BACKUP_NAME}_nextcloud_config.tar.gz" "⚙️  Restoring configuration..."
restore_volume "mariadb_data" "${BACKUP_NAME}_mariadb_data.tar.gz" "🗄️  Restoring database..."

echo ""
echo "✅ Restore completed: ${BACKUP_NAME}"
echo "🚀 Start platform with: ./up.sh"
