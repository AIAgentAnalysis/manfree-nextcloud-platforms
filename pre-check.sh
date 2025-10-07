#!/bin/bash

echo "🔍 Manfree Nextcloud Platform - Pre-Installation Check"
echo "====================================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "❌ Do not run as root. Use regular user account."
    exit 1
fi

# System requirements check
echo "📋 System Requirements:"
echo "----------------------"

# Check OS
OS=$(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")
echo "OS: $OS"

# Check RAM
RAM=$(free -h | awk '/^Mem:/ {print $2}')
echo "RAM: $RAM"

# Check disk space
DISK=$(df -h . | awk 'NR==2 {print $4}')
echo "Available Disk: $DISK"

echo ""
echo "🐳 Docker Requirements:"
echo "----------------------"

# Check Docker
if command -v docker >/dev/null 2>&1; then
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    echo "✅ Docker: $DOCKER_VERSION"
    
    # Check Docker permissions
    if docker ps >/dev/null 2>&1; then
        echo "✅ Docker permissions: OK"
    else
        echo "❌ Docker permissions: FAILED"
        echo "   Fix: sudo chmod 666 /var/run/docker.sock"
        ERRORS=1
    fi
else
    echo "❌ Docker: NOT INSTALLED"
    echo "   Install: sudo apt install docker.io"
    ERRORS=1
fi

# Check Docker Compose
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_VERSION=$(docker-compose --version | cut -d' ' -f4 | cut -d',' -f1)
    echo "✅ Docker Compose: $COMPOSE_VERSION"
else
    echo "❌ Docker Compose: NOT INSTALLED"
    echo "   Install: sudo apt install docker-compose"
    ERRORS=1
fi

# Check Git
if command -v git >/dev/null 2>&1; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo "✅ Git: $GIT_VERSION"
else
    echo "❌ Git: NOT INSTALLED"
    echo "   Install: sudo apt install git"
    ERRORS=1
fi

echo ""
echo "🌐 Network Check:"
echo "----------------"

# Check port 8090
if netstat -tuln 2>/dev/null | grep -q ":8090 "; then
    echo "❌ Port 8090: IN USE"
    echo "   Stop service using port 8090 or change port in docker-compose.yml"
    ERRORS=1
else
    echo "✅ Port 8090: AVAILABLE"
fi

# Check internet connectivity
if ping -c 1 google.com >/dev/null 2>&1; then
    echo "✅ Internet: CONNECTED"
else
    echo "⚠️  Internet: LIMITED (Docker images may not download)"
fi

echo ""
echo "📁 Project Files:"
echo "----------------"

# Check required files
REQUIRED_FILES=(".env" "docker-compose.yml" "Dockerfile" "up.sh" "down.sh")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file: EXISTS"
    else
        echo "❌ $file: MISSING"
        ERRORS=1
    fi
done

echo ""
if [ "${ERRORS:-0}" -eq 1 ]; then
    echo "❌ PRE-CHECK FAILED"
    echo "   Fix the issues above before running ./up.sh"
    exit 1
else
    echo "✅ PRE-CHECK PASSED"
    echo "   Ready to run: ./up.sh"
    exit 0
fi