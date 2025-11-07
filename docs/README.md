# ☁️ Manfree Nextcloud Platform

**Enterprise File Sharing & Collaboration Platform**

Complete documentation for the Manfree Technologies Nextcloud Platform - a Docker-based enterprise file sharing solution with automated backup/restore, multi-user support, and global access capabilities.

---

## 📚 Documentation Index

### 🚀 Quick Start
- **[Quick Start Guide](QUICK-START.md)** - Get running in 5 minutes
- **[Installation Guide](INSTALLATION.md)** - Complete setup process

### 👥 User Documentation  
- **[User Guide](USER-GUIDE.md)** - End-user instructions
- **[Troubleshooting](TROUBLESHOOTING.md)** - Common issues & solutions

### 📊 Project Information
- **[Project Status](PROJECT-STATUS.md)** - Current development status
- **[Cloudflare Tunnel](CLOUDFLARE-TUNNEL.md)** - Global access setup
- **[Maintenance Guide](MAINTENANCE.md)** - System maintenance

---

## 🎯 Platform Overview

**Manfree Nextcloud Platform** is an enterprise-ready file sharing and collaboration solution built with Docker for easy deployment and management at Manfree Technologies Institute.

### ✨ Key Features

**🔧 Technical Features:**
- ✅ Latest Nextcloud with automatic security updates
- ✅ MariaDB 10.6 database with Redis caching
- ✅ Automated backup/restore system
- ✅ 10GB file upload support
- ✅ Docker containerization for easy deployment
- ✅ Custom apps and themes support

**👥 Collaboration Features:**
- ✅ Multi-user file sharing and collaboration
- ✅ Real-time document editing
- ✅ Calendar and contacts integration
- ✅ Video calls and chat (Talk app)
- ✅ Project management (Deck app)
- ✅ Mobile and desktop sync clients

**🌐 Access Options:**
- ✅ Local network access (LAN)
- ✅ Global internet access (Cloudflare tunnel)
- ✅ Mobile apps (iOS/Android)
- ✅ Desktop sync clients (Windows/Mac/Linux)

---

## 🚀 Quick Commands

```bash
# Start platform (with auto-restore if backup exists)
./up.sh

# Stop platform (with auto-backup)
./down.sh

# Manual backup
./auto-backup.sh

# Manual restore
./auto-restore.sh

# Access: http://localhost:8070
```

---

## 📁 Project Structure

```
manfree-nextcloud-platforms/
├── 📄 README.md                 # This file - project overview
├── 📁 docs/                     # Complete documentation
│   ├── 📄 README.md            # Main documentation hub
│   ├── 📄 QUICK-START.md       # 5-minute setup guide
│   ├── 📄 INSTALLATION.md      # Detailed installation
│   ├── 📄 USER-GUIDE.md        # End-user instructions
│   ├── 📄 TROUBLESHOOTING.md   # Issue resolution
│   └── 📄 PROJECT-STATUS.md    # Development status
├── 🐳 docker-compose.yml       # Service orchestration
├── 🐳 Dockerfile               # Custom Nextcloud image
├── 🔧 docker-entrypoint.sh     # Customization automation
├── ⚙️ .env.example             # Environment template
├── 🚀 up.sh                    # Start platform script
├── 🛑 down.sh                  # Stop platform script
├── 💾 auto-backup.sh           # Backup automation
├── 🔄 auto-restore.sh          # Restore automation
├── 📁 backup/                  # Backup storage
├── 📁 customizations/          # Apps, themes, config
├── 📁 global-access/           # Tunnel solutions
└── 📄 VERSION                  # Platform version
```

---

## 🔧 System Requirements

### Minimum Requirements
- **OS:** Ubuntu 20.04+, macOS 10.15+, Windows 10 (WSL2)
- **RAM:** 2GB (4GB recommended)
- **Storage:** 20GB (100GB+ recommended)
- **Docker:** 20.10+
- **Docker Compose:** 2.0+

### Recommended Setup
- **RAM:** 8GB+ for multiple users
- **Storage:** SSD with 500GB+ space
- **Network:** Gigabit ethernet
- **CPU:** 4+ cores for optimal performance

---

## 🌐 Access Methods

### 1. Local Access
```bash
# Direct access on host machine
http://localhost:8070
```

### 2. LAN Access (Staff Network)
```bash
# Access from any device on same network
http://YOUR-SERVER-IP:8070

# Example: http://192.168.1.100:8070
```

### 3. Global Access (Internet)
```bash
# Via Cloudflare tunnel (see global-access/)
https://cloud.manfreetechnologies.com
```

---

## 👤 User Management

### Default Admin Account
- **Username:** `admin`
- **Password:** Set in `.env` file
- **Role:** Full administrative access

### Creating Staff Users
1. Login as admin
2. Go to Users section
3. Click "New user"
4. Set username, password, email
5. Assign storage quota (e.g., 50GB)
6. Add to appropriate groups

### User Groups
- **admin** - Full system access
- **staff** - Standard file access
- **guests** - Limited access for external users

---

## 💾 Backup & Restore System

### Automatic Backups
- **When:** Every time you run `./down.sh`
- **What:** Complete system state (files, database, config)
- **Where:** `backup/` directory
- **Format:** Compressed tar.gz files with timestamps

### Manual Backup
```bash
# Create backup anytime
./auto-backup.sh

# Backup includes:
# - All user files and folders
# - Database with user accounts and settings
# - Nextcloud configuration
# - Custom apps and themes
```

### Restore Process
```bash
# Restore from latest backup
./auto-restore.sh

# Or restore during startup
./up.sh
# (Will prompt if backup found)
```

### Backup Files
```
backup/
├── nextcloud-backup-20250107_143022_nextcloud_data.tar.gz
├── nextcloud-backup-20250107_143022_nextcloud_files.tar.gz
├── nextcloud-backup-20250107_143022_nextcloud_config.tar.gz
└── nextcloud-backup-20250107_143022_mariadb_data.tar.gz
```

---

## 🔒 Security Features

### Built-in Security
- **Brute Force Protection:** Automatic IP blocking
- **Two-Factor Authentication:** TOTP support
- **Encryption:** Files encrypted at rest
- **SSL/TLS:** HTTPS support via reverse proxy
- **User Isolation:** Proper file permissions
- **Regular Updates:** Latest security patches

### Security Best Practices
1. **Change default passwords** in `.env` file
2. **Enable 2FA** for all admin accounts
3. **Regular updates** via `docker-compose pull`
4. **Firewall configuration** for network access
5. **Backup encryption** for sensitive data

---

## 📱 Mobile & Desktop Apps

### Mobile Apps
- **iOS:** Download "Nextcloud" from App Store
- **Android:** Download "Nextcloud" from Google Play
- **Features:** Auto-upload photos, offline access, sharing

### Desktop Sync Clients
- **Download:** https://nextcloud.com/install/#install-clients
- **Platforms:** Windows, macOS, Linux
- **Features:** Two-way sync, selective sync, offline access

### Setup Instructions
1. Install app on device
2. Enter server URL: `http://YOUR-IP:8070`
3. Login with your credentials
4. Choose folders to sync
5. Enable auto-upload (mobile)

---

## 🔧 Customization

### Custom Apps
```bash
# Add apps to customizations/apps/
# They'll be installed automatically
customizations/apps/
├── calendar/
├── contacts/
└── talk/
```

### Custom Themes
```bash
# Add themes to customizations/themes/
customizations/themes/
├── manfree-theme/
└── dark-theme/
```

### Configuration
```bash
# Custom config in customizations/config/
customizations/config/
├── config.php
└── custom.config.php
```

---

## 📊 Monitoring & Maintenance

### Health Checks
```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs nextcloud

# Check Nextcloud status
docker exec -u www-data manfree_nextcloud php occ status

# Test Redis cache
docker exec manfree_nextcloud_redis redis-cli ping
```

### Performance Optimization
```bash
# Run maintenance tasks
docker exec -u www-data manfree_nextcloud php occ maintenance:repair
docker exec -u www-data manfree_nextcloud php occ db:add-missing-indices

# Clear cache
docker exec -u www-data manfree_nextcloud php occ maintenance:mode --on
docker exec -u www-data manfree_nextcloud php occ maintenance:mode --off
```

### Updates
```bash
# Update Docker images
docker-compose pull

# Restart with new images
./down.sh
./up.sh

# Update Nextcloud apps via web interface
```

---

## 🆘 Support & Troubleshooting

### Quick Diagnostics
```bash
# Check if services are running
docker-compose ps

# View recent logs
docker-compose logs --tail=50

# Check system resources
docker stats --no-stream

# Test network connectivity
curl -I http://localhost:8070
```

### Common Issues
- **Can't access from LAN:** Check firewall and trusted domains
- **Slow performance:** Check Redis cache and system resources
- **Upload fails:** Check file size limits and disk space
- **Login issues:** Verify credentials and check logs

### Getting Help
1. **Check [Troubleshooting Guide](TROUBLESHOOTING.md)** first
2. **Review logs:** `docker-compose logs`
3. **Check system resources:** `docker stats`
4. **Contact support** with error details and logs

---

## 🏢 Enterprise Features

### Multi-User Collaboration
- **Real-time editing:** Multiple users can edit documents simultaneously
- **Version control:** Automatic file versioning and history
- **Comments and sharing:** Collaborate with comments and shared folders
- **Activity feed:** Track all file and user activities

### Administrative Controls
- **User quotas:** Set storage limits per user or group
- **App management:** Control which apps users can install
- **Security policies:** Enforce password policies and 2FA
- **Audit logs:** Complete activity logging for compliance

### Integration Options
- **LDAP/Active Directory:** Enterprise user authentication
- **External storage:** Connect to existing file servers
- **API access:** Integrate with other business applications
- **Webhooks:** Automate workflows with external systems

---

## 📈 Scalability

### Single Server Setup (Current)
- **Users:** Up to 100 concurrent users
- **Storage:** Limited by host disk space
- **Performance:** Good for small to medium teams

### Future Scaling Options
- **Load balancing:** Multiple Nextcloud instances
- **Database clustering:** High-availability database
- **Object storage:** S3-compatible external storage
- **CDN integration:** Global content delivery

---

## 🎯 Use Cases

### For Manfree Technologies Institute

**Staff File Sharing:**
- Replace email attachments with secure links
- Collaborate on documents in real-time
- Access files from anywhere (office, home, mobile)
- Automatic backup of all work files

**Project Management:**
- Organize files by project or department
- Share folders with specific team members
- Track document versions and changes
- Integrate with calendar for deadlines

**Client Collaboration:**
- Share large files with clients securely
- Provide temporary access to project folders
- Collect files from clients via upload links
- Maintain professional branded interface

**Data Security:**
- Keep sensitive data on-premises
- Control who has access to what files
- Audit trail of all file activities
- Encrypted storage and transmission

---

## 🔄 Migration & Integration

### Migrating from Other Platforms

**From Google Drive:**
1. Export data from Google Takeout
2. Upload to Nextcloud via web interface
3. Recreate folder structure
4. Update sharing permissions

**From Dropbox:**
1. Download all files locally
2. Use desktop sync client to upload
3. Maintain folder organization
4. Set up new sharing links

**From OneDrive:**
1. Use OneDrive sync to download locally
2. Copy to Nextcloud sync folder
3. Wait for automatic upload
4. Verify all files transferred

### Integration with Existing Systems

**Email Integration:**
- Send Nextcloud links instead of attachments
- Configure email notifications for shares
- Set up automatic file organization from email

**Backup Integration:**
- Include Nextcloud backups in existing backup systems
- Set up offsite backup replication
- Monitor backup success and failures

---

## 📋 Compliance & Governance

### Data Governance
- **Data location:** All data stored on-premises
- **Access control:** Granular permissions system
- **Retention policies:** Automatic file lifecycle management
- **Audit trails:** Complete activity logging

### Compliance Features
- **GDPR compliance:** Data portability and deletion rights
- **SOC 2 Type II:** Security and availability controls
- **HIPAA ready:** Healthcare data protection (with proper configuration)
- **ISO 27001:** Information security management

---

## 🌟 Success Metrics

### Performance Indicators
- **User adoption:** Track active users and usage patterns
- **Storage utilization:** Monitor space usage and growth
- **Collaboration metrics:** Measure file sharing and editing
- **System uptime:** Maintain 99.9% availability target

### Business Benefits
- **Cost savings:** Reduce cloud storage subscriptions
- **Productivity gains:** Faster file access and collaboration
- **Security improvement:** Better control over sensitive data
- **Compliance readiness:** Meet regulatory requirements

---

## 🚀 Getting Started

Ready to deploy? Follow these steps:

1. **[Quick Start](QUICK-START.md)** - 5-minute deployment
2. **[Installation Guide](INSTALLATION.md)** - Detailed setup
3. **[User Guide](USER-GUIDE.md)** - Learn to use the platform
4. **[Troubleshooting](TROUBLESHOOTING.md)** - Solve common issues

---

## 📞 Contact & Support

**Manfree Technologies Institute**
- **Platform:** Nextcloud Enterprise
- **Version:** Latest (Auto-updating)
- **Support:** IT Department
- **Documentation:** This repository

---

**Built with ❤️ for Manfree Technologies Institute** ☁️

*Empowering secure collaboration and file sharing for the digital age.*