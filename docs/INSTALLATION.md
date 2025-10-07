# 🚀 Installation Guide - Nextcloud Platform

**Complete step-by-step installation guide for all platforms**

---

## 📋 Pre-Installation Checklist

### System Requirements

**Minimum:**
- 2GB RAM
- 20GB storage
- Docker 20.10+
- Docker Compose 2.0+

**Recommended:**
- 4GB+ RAM
- 100GB+ SSD storage
- Gigabit network

### Verify Prerequisites

```bash
# Check Docker
docker --version
docker-compose --version

# Check resources
free -h
df -h

# Test Docker
docker run hello-world
```

---

## 🐧 Ubuntu/Debian Installation

### Step 1: Install Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install docker.io docker-compose git -y

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
exit
```

### Step 2: Clone Repository

```bash
# Navigate to workspace
cd ~/workspace

# Clone repository
git clone https://github.com/AIAgentAnalysis/manfree-nextcloud-platforms.git
cd manfree-nextcloud-platforms

# Make scripts executable
chmod +x *.sh
```

### Step 3: Configure Environment

```bash
# Edit .env file
nano .env

# Update these critical values:
# - NEXTCLOUD_ADMIN_PASSWORD (change from default)
# - MYSQL_ROOT_PASSWORD (change from default)
# - NEXTCLOUD_TRUSTED_DOMAINS (add your IP)

# Get your IP
hostname -I
```

### Step 4: Pre-pull Images

```bash
# Pull required Docker images
docker pull nextcloud:latest
docker pull mariadb:10.6
docker pull redis:alpine
```

### Step 5: Deploy

```bash
# Start platform
./up.sh

# Wait 2-3 minutes for initialization
# Check status
docker-compose ps
```

### Step 6: Access Nextcloud

```bash
# Get your IP
IP=$(hostname -I | awk '{print $1}')

# Access URLs:
# Local: http://localhost:8090
# LAN: http://$IP:8090

# Login with credentials from .env file
```

---

## 🍎 macOS Installation

### Step 1: Install Docker Desktop

```bash
# Install via Homebrew
brew install --cask docker

# Or download from:
# https://www.docker.com/products/docker-desktop

# Start Docker Desktop application
```

### Step 2: Configure Docker Resources

```
Docker Desktop → Settings → Resources:
- Memory: 4GB minimum
- Disk: 50GB minimum
```

### Step 3: Clone and Deploy

```bash
# Open Terminal
cd ~/workspace

# Clone repository
git clone https://github.com/AIAgentAnalysis/manfree-nextcloud-platforms.git
cd manfree-nextcloud-platforms

# Make scripts executable
chmod +x *.sh

# Configure .env
nano .env

# Deploy
./up.sh
```

---

## 🪟 Windows (WSL2) Installation

### Step 1: Enable WSL2

```powershell
# Run PowerShell as Administrator
wsl --install

# Restart computer
```

### Step 2: Install Docker Desktop

1. Download Docker Desktop for Windows
2. Install with WSL2 backend
3. Enable WSL2 integration in settings

### Step 3: Deploy in WSL2

```bash
# Open WSL2 terminal
wsl

# Navigate to workspace
cd ~/workspace

# Clone repository
git clone https://github.com/AIAgentAnalysis/manfree-nextcloud-platforms.git
cd manfree-nextcloud-platforms

# Make scripts executable
chmod +x *.sh

# Configure and deploy
nano .env
./up.sh
```

---

## 🌐 Network Configuration

### Local Access Only

**Default configuration works:**
```bash
# Access: http://localhost:8090
# No additional configuration needed
```

### LAN Access (Staff)

**1. Get Host IP:**
```bash
hostname -I
# Example: 192.168.1.100
```

**2. Update .env:**
```bash
nano .env

# Add your IP to trusted domains
NEXTCLOUD_TRUSTED_DOMAINS=localhost 192.168.1.100 files.manfreetechnologies.com
```

**3. Configure Firewall:**
```bash
# Ubuntu/Debian
sudo ufw allow 8090

# CentOS/RHEL
sudo firewall-cmd --add-port=8090/tcp --permanent
sudo firewall-cmd --reload
```

**4. Restart Platform:**
```bash
./down.sh
./up.sh
```

**5. Test Access:**
```bash
# From another device on same network
# Open browser: http://192.168.1.100:8090
```

### Global Access (Internet)

**See `global-access/` directory for:**
- Cloudflare tunnel setup (permanent)
- Temporary tunnel options (ngrok, etc.)

---

## ⚙️ Post-Installation Configuration

### First Login

1. Open browser: `http://localhost:8090`
2. Login with admin credentials from `.env`
3. Complete setup wizard
4. Install recommended apps

### Recommended Apps

**Install via Apps menu:**
- Calendar
- Contacts
- Talk (video calls)
- Deck (project management)
- Forms
- Photos

### User Creation

**Create staff users:**
1. Profile icon → Users
2. Click "New user"
3. Enter details
4. Set quota (e.g., 50GB)
5. Assign to groups

### Storage Configuration

**Set default quota:**
1. Settings → Administration → Sharing
2. Set "Default quota" for new users
3. Example: 50GB per user

---

## 🔒 Security Hardening

### Change Default Passwords

```bash
# Edit .env
nano .env

# Update:
NEXTCLOUD_ADMIN_PASSWORD=YourStrongPassword123!
MYSQL_ROOT_PASSWORD=YourDatabasePassword456!

# Restart
./down.sh
./up.sh
```

### Enable Two-Factor Authentication

1. Login as admin
2. Settings → Security
3. Enable "Two-Factor TOTP"
4. Scan QR code with authenticator app

### Configure Brute Force Protection

**Already enabled by default:**
- Failed login attempts tracked
- IP blocking after multiple failures
- Automatic unblock after time period

### Regular Updates

```bash
# Update platform
docker-compose pull
docker-compose up -d

# Update apps via web interface
# Settings → Administration → Overview
```

---

## 📊 Verification

### Check Installation

```bash
# Container status
docker-compose ps
# All should show "Up"

# Check logs
docker-compose logs nextcloud | tail -20
# Should show no errors

# Test Redis
docker exec manfree_nextcloud_redis redis-cli ping
# Should return: PONG

# Test database
docker exec manfree_nextcloud_db mysql -u nextcloud -pnextcloud_secure_2025 -e "SHOW DATABASES;"
# Should list: nextcloud
```

### Performance Test

```bash
# Check resource usage
docker stats --no-stream

# Run Nextcloud checks
docker exec -u www-data manfree_nextcloud php occ status
# Should show: installed: true

# Check for warnings
docker exec -u www-data manfree_nextcloud php occ config:list system
```

---

## 🆘 Installation Troubleshooting

### Docker Not Found

```bash
# Install Docker
sudo apt install docker.io docker-compose

# Add user to group
sudo usermod -aG docker $USER

# Logout and login
```

### Permission Denied

```bash
# Make scripts executable
chmod +x *.sh

# Check Docker group
groups
# Should include: docker
```

### Port Already in Use

```bash
# Check what's using port 8090
sudo netstat -tlnp | grep 8090

# Kill process or change port in docker-compose.yml
```

### Container Won't Start

```bash
# Check logs
docker-compose logs

# Rebuild
docker-compose down
docker-compose up -d --build
```

### Can't Access from LAN

```bash
# Check firewall
sudo ufw status
sudo ufw allow 8090

# Check trusted domains
docker exec manfree_nextcloud cat /var/www/html/config/config.php | grep trusted_domains

# Add your IP to .env and restart
```

---

## 📞 Support

**If installation fails:**
1. Check logs: `docker-compose logs`
2. Verify requirements: `docker --version`
3. Review this guide step-by-step
4. Check TROUBLESHOOTING.md
5. Contact support with error details

---

**Installation Complete!** 🎉

Next steps:
- Create user accounts
- Install apps
- Configure storage
- Setup backups
- See USER-GUIDE.md for usage instructions
