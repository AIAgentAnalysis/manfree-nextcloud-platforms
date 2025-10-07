#!/bin/bash

echo "⚙️  Manfree Nextcloud Platform - Post-Installation Setup"
echo "======================================================="
echo ""

# Check if platform is running
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Platform not running. Start with: ./up.sh"
    exit 1
fi

echo "🔧 Configuring additional apps and settings..."
echo ""

# Enable additional security apps
echo "🔐 Enabling security features..."
docker exec -u www-data manfree_nextcloud php occ app:enable suspicious_login 2>/dev/null || true
docker exec -u www-data manfree_nextcloud php occ app:enable twofactor_webauthn 2>/dev/null || true

# Configure system settings
echo "⚙️  Configuring system settings..."
docker exec -u www-data manfree_nextcloud php occ config:system:set default_phone_region --value="IN"
docker exec -u www-data manfree_nextcloud php occ config:system:set skeletondirectory --value=""

# Set up maintenance window
docker exec -u www-data manfree_nextcloud php occ config:system:set maintenance_window_start --type=integer --value=1

# Configure file handling
docker exec -u www-data manfree_nextcloud php occ config:system:set preview_max_x --type=integer --value=2048
docker exec -u www-data manfree_nextcloud php occ config:system:set preview_max_y --type=integer --value=2048

echo ""
echo "📊 Current App Status:"
echo "---------------------"
docker exec -u www-data manfree_nextcloud php occ app:list | grep -E "(calendar|contacts|mail|spreed|notes|encryption|twofactor)" | head -10

echo ""
echo "🎯 Recommended Next Steps:"
echo "-------------------------"
echo "1. Install missing apps via web interface:"
echo "   - Deck (Project management)"
echo "   - Forms (Surveys)"
echo ""
echo "2. Create user accounts:"
echo "   - Go to: http://localhost:8090"
echo "   - Login as admin"
echo "   - Users → Add users"
echo ""
echo "3. Configure external storage (if needed):"
echo "   - Settings → Administration → External storage"
echo ""
echo "✅ Post-setup configuration completed!"