#!/bin/bash
set -e

# Error handling
trap 'echo "❌ Backup failed at line $LINENO"; exit 1' ERR

# Variables for maintainability
PROJECT_NAME="manfree-nextcloud-platforms"
VOLUME_PREFIX="${PROJECT_NAME}_"

BACKUP_DIR="./backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="nextcloud-backup-${TIMESTAMP}"

echo "💾 Creating Nextcloud backup: ${BACKUP_NAME}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Backup Nextcloud data
echo "📦 Backing up Nextcloud data..."
docker run --rm \
    -v "${VOLUME_PREFIX}nextcloud_data":/data \
    -v "$(pwd)/${BACKUP_DIR}:/backup" \
    alpine tar czf "/backup/${BACKUP_NAME}_nextcloud_data.tar.gz" -C /data .

# Backup Nextcloud files (user data)
echo "📁 Backing up user files..."
docker run --rm \
    -v "${VOLUME_PREFIX}nextcloud_files":/data \
    -v "$(pwd)/${BACKUP_DIR}:/backup" \
    alpine tar czf "/backup/${BACKUP_NAME}_nextcloud_files.tar.gz" -C /data .

# Backup Nextcloud config
echo "⚙️  Backing up configuration..."
docker run --rm \
    -v "${VOLUME_PREFIX}nextcloud_config":/data \
    -v "$(pwd)/${BACKUP_DIR}:/backup" \
    alpine tar czf "/backup/${BACKUP_NAME}_nextcloud_config.tar.gz" -C /data .

# Backup MariaDB
echo "🗄️  Backing up database..."
docker run --rm \
    -v "${VOLUME_PREFIX}mariadb_data":/data \
    -v "$(pwd)/${BACKUP_DIR}:/backup" \
    alpine tar czf "/backup/${BACKUP_NAME}_mariadb_data.tar.gz" -C /data .

# Check sizes and warn about Git limits
echo ""
echo "📊 Backup size analysis:"
MAX_SIZE_MB=90
TOTAL_SIZE=0
for file in "${BACKUP_DIR}/${BACKUP_NAME}"*.tar.gz; do
    if [ -f "$file" ]; then
        size_mb=$(du -m "$file" | cut -f1)
        TOTAL_SIZE=$((TOTAL_SIZE + size_mb))
        echo "  $(basename "$file"): ${size_mb}MB"
        
        if [ "$size_mb" -gt "$MAX_SIZE_MB" ]; then
            echo "⚠️  WARNING: $(basename "$file") (${size_mb}MB) exceeds ${MAX_SIZE_MB}MB"
            echo "   Consider using Git LFS: git lfs install && git lfs track '*.tar.gz'"
        fi
    fi
done
echo "  Total: ${TOTAL_SIZE}MB"

# Cleanup old backups - keep only last 3
echo ""
echo "🧹 Cleaning up old backups (keeping last 3)..."
find "${BACKUP_DIR}" -name "*_nextcloud_data.tar.gz" -type f -printf '%T@ %p\n' 2>/dev/null | \
    sort -rn | tail -n +4 | cut -d' ' -f2- | while read old_backup; do
    old_name=$(basename "$old_backup" "_nextcloud_data.tar.gz")
    echo "  Removing: $old_name"
    rm -f "${BACKUP_DIR}/${old_name}"*.tar.gz
done

echo ""
echo "✅ Backup completed: ${BACKUP_NAME}"
echo "📁 Location: ${BACKUP_DIR}/"
echo "💾 Total size: ${TOTAL_SIZE}MB"
