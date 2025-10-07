# 🚀 Deployment Guide - Manfree Nextcloud Platform

**Complete deployment checklist for production use**

---

## 📋 Pre-Deployment Checklist

### **1. Run Pre-Installation Check**
```bash
./pre-check.sh
```

### **2. System Requirements**
- **OS:** Ubuntu 20.04+ / Debian 11+
- **RAM:** 4GB minimum, 8GB recommended
- **Storage:** 100GB+ SSD recommended
- **Docker:** 20.10+
- **Docker Compose:** 2.0+

### **3. Network Requirements**
- Port 8090 available
- Internet access for Docker images
- Firewall configured (if using LAN access)

---

## 🚀 Deployment Steps

### **Step 1: Pre-Check**
```bash
# Verify system readiness
./pre-check.sh
```

### **Step 2: Configure Environment**
```bash
# Edit configuration
nano .env

# Update these values:
# - NEXTCLOUD_ADMIN_PASSWORD
# - MYSQL_ROOT_PASSWORD  
# - MYSQL_PASSWORD
# - NEXTCLOUD_TRUSTED_DOMAINS
```

### **Step 3: Deploy Platform**
```bash
# Start platform
./up.sh

# Wait for initialization (2-3 minutes)
```

### **Step 4: Post-Setup Configuration**
```bash
# Configure additional settings
./post-setup.sh
```

### **Step 5: Web Interface Setup**
1. **Access:** http://localhost:8090
2. **Login:** admin / (password from .env)
3. **Install apps:** Deck, Forms
4. **Create users:** Add staff accounts
5. **Configure storage:** Set quotas

---

## 🔐 Security Configuration

### **Encryption (Already Enabled)**
- Server-side encryption: ✅ Enabled
- New files automatically encrypted
- Existing files can be encrypted later

### **Two-Factor Authentication**
- TOTP: ✅ Enabled
- WebAuthn: ✅ Enabled  
- Backup codes: ✅ Enabled

### **Access Control**
- Brute force protection: ✅ Enabled
- Suspicious login detection: ✅ Enabled
- Admin audit logging: ✅ Enabled

---

## 📱 Essential Apps Status

### **✅ Installed & Configured:**
- Calendar, Contacts, Mail, Talk
- Photos, Notes, Text editor
- Office documents (Richdocuments)
- External storage, Encryption

### **📋 Install via Web Interface:**
- **Deck** - Project management
- **Forms** - Surveys and data collection

---

## 🌐 Access Configuration

### **Local Access**
- URL: http://localhost:8090
- No additional configuration needed

### **LAN Access**
1. **Add IP to .env:**
   ```bash
   NEXTCLOUD_TRUSTED_DOMAINS=localhost YOUR-IP files.manfreetechnologies.com
   ```

2. **Configure firewall:**
   ```bash
   sudo ufw allow 8090
   ```

3. **Restart platform:**
   ```bash
   ./down.sh && ./up.sh
   ```

### **Global Access**
- Configure Cloudflare tunnel (see global-access/ folder)
- Add tunnel token to .env file

---

## 🔧 Maintenance

### **Daily Operations**
```bash
# Start platform
./up.sh

# Stop platform (with backup)
./down.sh

# Manual backup
./auto-backup.sh
```

### **Updates**
```bash
# Update Docker images
docker-compose pull

# Restart with new images
./down.sh && ./up.sh
```

### **Monitoring**
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs nextcloud

# Check system health
docker exec -u www-data manfree_nextcloud php occ status
```

---

## 🆘 Troubleshooting

### **Platform Won't Start**
1. Run pre-check: `./pre-check.sh`
2. Check logs: `docker-compose logs`
3. Verify .env configuration
4. Check port availability

### **Can't Access from LAN**
1. Verify trusted domains in .env
2. Check firewall: `sudo ufw status`
3. Restart platform after changes

### **Performance Issues**
1. Check resources: `docker stats`
2. Run maintenance: `./post-setup.sh`
3. Monitor disk space: `df -h`

---

## 📞 Support

**Documentation:**
- [Complete Guide](docs/README.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [User Guide](docs/USER-GUIDE.md)

**System Information:**
- Platform: Nextcloud 32.0.0
- Database: MariaDB 10.6
- Cache: Redis Alpine
- Custom build with enterprise features

---

**Deployment Status: ✅ PRODUCTION READY**

*Built for Manfree Technologies Institute*