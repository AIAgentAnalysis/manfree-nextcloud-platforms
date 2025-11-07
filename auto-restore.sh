#!/bin/bash
set -e

# Error handling
trap 'echo "❌ Restore failed at line $LINENO"; exit 1' ERR

# Variables
PROJECT_NAME="manfree-nextcloud-platforms"
VOLUME_PREFIX="${PROJECT_NAME}_"
BACKUP_DIR="./backup"

# Check if backup directory exists
if [ ! -d "${BACKUP_DIR}" ]; then
    echo "ℹ️  No backup directory found. Starting fresh."
    exit 0
fi

# Find latest backup
LATEST_BACKUP=$(ls -t "${BACKUP_DIR}"/*_nextcloud_data.tar.gz 2>/dev/null | head -n1 || echo "")

if [ -z "${LATEST_BACKUP}" ]; then
    echo "ℹ️  No backup found. Starting fresh."
    exit 0
fi

# Extract backup name
BACKUP_NAME=$(basename "${LATEST_BACKUP}" "_nextcloud_data.tar.gz")

echo "🔄 Restoring backup: ${BACKUP_NAME}"

# Create volumes if they don't exist
docker volume create manfree-nextcloud-platforms_nextcloud_data >/dev/null 2>&1 || true
docker volume create manfree-nextcloud-platforms_nextcloud_files >/dev/null 2>&1 || true
docker volume create manfree-nextcloud-platforms_nextcloud_config >/dev/null 2>&1 || true
docker volume create manfree-nextcloud-platforms_mariadb_data >/dev/null 2>&1 || true

# Restore Nextcloud data
if [ -f "${BACKUP_DIR}/${BACKUP_NAME}_nextcloud_data.tar.gz" ]; then
    echo "Restoring Nextcloud data..."
    docker run --rm \
        -v manfree-nextcloud-platforms_nextcloud_data:/data \
        -v "$(pwd)/${BACKUP_DIR}:/backup" \
        alpine tar xzf "/backup/${BACKUP_NAME}_nextcloud_data.tar.gz" -C /data
fi

# Restore Nextcloud files
if [ -f "${BACKUP_DIR}/${BACKUP_NAME}_nextcloud_files.tar.gz" ]; then
    echo "Restoring Nextcloud files..."
    docker run --rm \
        -v manfree-nextcloud-platforms_nextcloud_files:/data \
        -v "$(pwd)/${BACKUP_DIR}:/backup" \
        alpine tar xzf "/backup/${BACKUP_NAME}_nextcloud_files.tar.gz" -C /data
fi

# Restore Nextcloud config
if [ -f "${BACKUP_DIR}/${BACKUP_NAME}_nextcloud_config.tar.gz" ]; then
    echo "Restoring Nextcloud config..."
    docker run --rm \
        -v manfree-nextcloud-platforms_nextcloud_config:/data \
        -v "$(pwd)/${BACKUP_DIR}:/backup" \
        alpine tar xzf "/backup/${BACKUP_NAME}_nextcloud_config.tar.gz" -C /data
fi

# Restore MariaDB
if [ -f "${BACKUP_DIR}/${BACKUP_NAME}_mariadb_data.tar.gz" ]; then
    echo "Restoring database..."
    docker run --rm \
        -v manfree-nextcloud-platforms_mariadb_data:/data \
        -v "$(pwd)/${BACKUP_DIR}:/backup" \
        alpine tar xzf "/backup/${BACKUP_NAME}_mariadb_data.tar.gz" -C /data
fi

echo "✅ Restore completed: ${BACKUP_NAME}"