#!/bin/bash

# Health Check Script for Nextcloud Platform
# Monitors system health and reports issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏥 Nextcloud Platform Health Check${NC}"
echo "=================================="
echo ""

# Check 1: Docker Service
echo -n "Docker Service: "
if systemctl is-active docker &>/dev/null; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${RED}❌ Not Running${NC}"
    exit 1
fi

# Check 2: Containers Status
echo -n "Nextcloud Container: "
if docker ps | grep -q "manfree_nextcloud"; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${RED}❌ Not Running${NC}"
fi

echo -n "Database Container: "
if docker ps | grep -q "manfree_nextcloud_db"; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${RED}❌ Not Running${NC}"
fi

echo -n "Redis Container: "
if docker ps | grep -q "manfree_nextcloud_redis"; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${RED}❌ Not Running${NC}"
fi

# Check 3: Disk Space
echo -n "Disk Space: "
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo -e "${GREEN}✅ ${DISK_USAGE}% used${NC}"
elif [ "$DISK_USAGE" -lt 90 ]; then
    echo -e "${YELLOW}⚠️  ${DISK_USAGE}% used${NC}"
else
    echo -e "${RED}❌ ${DISK_USAGE}% used (Critical!)${NC}"
fi

# Check 4: Memory Usage
echo -n "Memory Usage: "
MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
if [ "$MEM_USAGE" -lt 80 ]; then
    echo -e "${GREEN}✅ ${MEM_USAGE}% used${NC}"
elif [ "$MEM_USAGE" -lt 90 ]; then
    echo -e "${YELLOW}⚠️  ${MEM_USAGE}% used${NC}"
else
    echo -e "${RED}❌ ${MEM_USAGE}% used (High!)${NC}"
fi

# Check 5: Nextcloud Status
echo -n "Nextcloud Status: "
if docker exec -u www-data manfree_nextcloud php occ status 2>/dev/null | grep -q "installed: true"; then
    echo -e "${GREEN}✅ Installed${NC}"
else
    echo -e "${RED}❌ Not Installed${NC}"
fi

# Check 6: Database Connection
echo -n "Database Connection: "
if docker exec manfree_nextcloud_db mysqladmin ping -h localhost &>/dev/null; then
    echo -e "${GREEN}✅ Connected${NC}"
else
    echo -e "${RED}❌ Failed${NC}"
fi

# Check 7: Redis Connection
echo -n "Redis Connection: "
if docker exec manfree_nextcloud_redis redis-cli ping &>/dev/null | grep -q "PONG"; then
    echo -e "${GREEN}✅ Connected${NC}"
else
    echo -e "${RED}❌ Failed${NC}"
fi

# Check 8: Web Access
echo -n "Web Access (Local): "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8070 | grep -q "302\|200"; then
    echo -e "${GREEN}✅ Accessible${NC}"
else
    echo -e "${RED}❌ Not Accessible${NC}"
fi

# Check 9: Cloudflare Tunnel
echo -n "Cloudflare Tunnel: "
if systemctl is-active cloudflared &>/dev/null; then
    echo -e "${GREEN}✅ Active${NC}"
else
    echo -e "${YELLOW}⚠️  Inactive${NC}"
fi

# Check 10: Backup Status
echo -n "Latest Backup: "
if [ -d "backup" ] && [ "$(ls -A backup/*.tar.gz 2>/dev/null)" ]; then
    LATEST_BACKUP=$(ls -t backup/*_nextcloud_data.tar.gz 2>/dev/null | head -n1)
    BACKUP_DATE=$(stat -c %y "$LATEST_BACKUP" 2>/dev/null | cut -d' ' -f1)
    echo -e "${GREEN}✅ $BACKUP_DATE${NC}"
else
    echo -e "${YELLOW}⚠️  No backups found${NC}"
fi

echo ""
echo "=================================="
echo -e "${BLUE}Health Check Complete${NC}"
echo ""

# Summary
ISSUES=0
if ! docker ps | grep -q "manfree_nextcloud"; then ((ISSUES++)); fi
if ! docker ps | grep -q "manfree_nextcloud_db"; then ((ISSUES++)); fi
if ! docker ps | grep -q "manfree_nextcloud_redis"; then ((ISSUES++)); fi
if [ "$DISK_USAGE" -gt 90 ]; then ((ISSUES++)); fi
if [ "$MEM_USAGE" -gt 90 ]; then ((ISSUES++)); fi

if [ "$ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ All systems operational${NC}"
    exit 0
else
    echo -e "${RED}⚠️  $ISSUES issue(s) detected${NC}"
    echo "Run 'docker-compose logs' for details"
    exit 1
fi
