#!/bin/bash
set -e

echo "💾 Backing up current customizations..."

# Create customizations backup directory
mkdir -p customizations/{apps,themes,config}

# Backup custom apps
echo "Backing up custom apps..."
if docker exec manfree_nextcloud test -d /var/www/html/custom_apps 2>/dev/null; then
    docker exec manfree_nextcloud find /var/www/html/custom_apps -maxdepth 1 -type d ! -name "custom_apps" -exec basename {} \; 2>/dev/null | while read app; do
        if [ "$app" != "custom_apps" ]; then
            docker cp manfree_nextcloud:/var/www/html/custom_apps/$app customizations/apps/ 2>/dev/null || true
        fi
    done
fi

# Backup custom themes
echo "Backing up custom themes..."
if docker exec manfree_nextcloud test -d /var/www/html/themes 2>/dev/null; then
    docker exec manfree_nextcloud find /var/www/html/themes -maxdepth 1 -type d ! -name "themes" -exec basename {} \; 2>/dev/null | while read theme; do
        if [ "$theme" != "themes" ]; then
            docker cp manfree_nextcloud:/var/www/html/themes/$theme customizations/themes/ 2>/dev/null || true
        fi
    done
fi

# Backup config customizations
echo "Backing up config customizations..."
if docker exec manfree_nextcloud test -f /var/www/html/config/config.php 2>/dev/null; then
    docker cp manfree_nextcloud:/var/www/html/config/config.php customizations/config/config.php 2>/dev/null || true
fi

echo "✅ Customizations backed up to ./customizations/"
echo "📋 These will be automatically restored during container rebuilds"