#!/bin/bash
set -e

# Install custom apps if they exist
if [ -d "/tmp/custom_apps" ] && [ "$(ls -A /tmp/custom_apps)" ]; then
    echo "Installing custom apps..."
    if ! cp -r /tmp/custom_apps/* /var/www/html/custom_apps/ 2>/dev/null; then
        echo "Warning: Failed to copy some custom apps"
    fi
    chown -R www-data:www-data /var/www/html/custom_apps 2>/dev/null || echo "Warning: Failed to set app permissions"
fi

# Install custom themes if they exist
if [ -d "/tmp/custom_themes" ] && [ "$(ls -A /tmp/custom_themes)" ]; then
    echo "Installing custom themes..."
    if ! cp -r /tmp/custom_themes/* /var/www/html/themes/ 2>/dev/null; then
        echo "Warning: Failed to copy some custom themes"
    fi
    chown -R www-data:www-data /var/www/html/themes 2>/dev/null || echo "Warning: Failed to set theme permissions"
fi

# Apply custom config if exists
if [ -d "/tmp/custom_config" ] && [ "$(ls -A /tmp/custom_config)" ]; then
    echo "Applying custom configuration..."
    if ! cp -r /tmp/custom_config/* /var/www/html/config/ 2>/dev/null; then
        echo "Warning: Failed to copy some config files"
    fi
    chown -R www-data:www-data /var/www/html/config 2>/dev/null || echo "Warning: Failed to set config permissions"
fi

# Execute the original Nextcloud entrypoint
exec /entrypoint.sh "$@"
