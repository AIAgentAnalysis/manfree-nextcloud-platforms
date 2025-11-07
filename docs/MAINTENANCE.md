# 🔧 Maintenance Guide

**Keep your Nextcloud platform running smoothly**

---

## 📅 Regular Maintenance Schedule

### Daily Tasks (Automated)
- ✅ Background jobs (cron)
- ✅ File scanning
- ✅ Cache cleanup
- ✅ Log rotation

### Weekly Tasks
- 🔍 Check system health
- 📊 Review storage usage
- 🔐 Review security logs
- 📈 Monitor performance

### Monthly Tasks
- 🔄 Update Docker images
- 💾 Verify backups
- 🧹 Clean up old files
- 📧 Review user accounts

---

## 🔍 Health Checks

### System Status

```bash
# Check all containers
docker-compose ps

# Check Nextcloud status
docker exec -u www-data manfree_nextcloud php occ status

# Check system info
docker exec -u www-data manfree_nextcloud php occ system:info
```

### Database Health

```bash
# Check database
docker exec -u www-data manfree_nextcloud php occ db:check

# Add missing indices
docker exec -u www-data manfree_nextcloud php occ db:add-missing-indices

# Convert file cache
docker exec -u www-data manfree_nextcloud php occ db:convert-filecache-bigint
```

### Redis Cache

```bash
# Test Redis connection
docker exec manfree_nextcloud_redis redis-cli ping

# Check Redis stats
docker exec manfree_nextcloud_redis redis-cli info stats
```

---

## 🧹 Cleanup Tasks

### Clear Caches

```bash
# Clear all caches
docker exec -u www-data manfree_nextcloud php occ maintenance:repair --include-expensive

# Clear specific caches
docker exec -u www-data manfree_nextcloud php occ files:cleanup
```

### Remove Deleted Files

```bash
# Clean up trashbin (older than 30 days)
docker exec -u www-data manfree_nextcloud php occ trashbin:cleanup --all-users

# Clean up versions
docker exec -u www-data manfree_nextcloud php occ versions:cleanup
```

### Log Management

```bash
# View logs
docker exec manfree_nextcloud tail -f /var/www/html/data/nextcloud.log

# Clear old logs
docker exec -u www-data manfree_nextcloud php occ log:manage --clear
```

---

## 🔄 Updates

### Update Docker Images

```bash
# Pull latest images
docker-compose pull

# Restart with new images
./down.sh
./up.sh
```

### Update Nextcloud Apps

```bash
# List available updates
docker exec -u www-data manfree_nextcloud php occ app:update --all --showonly

# Update all apps
docker exec -u www-data manfree_nextcloud php occ app:update --all
```

### Update Nextcloud Core

Updates are handled automatically by the Docker image. To force update:

```bash
# Backup first!
./auto-backup.sh

# Pull latest Nextcloud image
docker-compose pull nextcloud

# Rebuild and restart
docker-compose up -d --build
```

---

## 💾 Backup Management

### Create Backup

```bash
# Manual backup
./auto-backup.sh

# Backup is created automatically when running
./down.sh
```

### Verify Backup

```bash
# Check backup files
ls -lh backup/

# Check backup integrity
tar -tzf backup/nextcloud-backup-*.tar.gz | head
```

### Restore from Backup

```bash
# Restore latest backup
./auto-restore.sh

# Or restore during startup
./up.sh
# (Will prompt if backup found)
```

### Backup Retention

```bash
# Automatic cleanup keeps last 3 backups
# Manual cleanup:
cd backup/
ls -t *_nextcloud_data.tar.gz | tail -n +4 | xargs rm -f
```

---

## 📊 Performance Optimization

### Database Optimization

```bash
# Optimize database tables
docker exec manfree_nextcloud_db mysqlcheck -u root -p${MYSQL_ROOT_PASSWORD} --optimize --all-databases

# Analyze tables
docker exec manfree_nextcloud_db mysqlcheck -u root -p${MYSQL_ROOT_PASSWORD} --analyze --all-databases
```

### File Scanning

```bash
# Scan all files
docker exec -u www-data manfree_nextcloud php occ files:scan --all

# Scan specific user
docker exec -u www-data manfree_nextcloud php occ files:scan username
```

### Preview Generation

```bash
# Pre-generate previews
docker exec -u www-data manfree_nextcloud php occ preview:pre-generate
```

---

## 🔐 Security Maintenance

### Security Scan

```bash
# Run security scan
docker exec -u www-data manfree_nextcloud php occ security:bruteforce:reset

# Check for security issues
docker exec -u www-data manfree_nextcloud php occ security:certificates
```

### User Management

```bash
# List all users
docker exec -u www-data manfree_nextcloud php occ user:list

# Disable inactive user
docker exec -u www-data manfree_nextcloud php occ user:disable username

# Reset user password
docker exec -u www-data manfree_nextcloud php occ user:resetpassword username
```

### Audit Logs

```bash
# View recent activities
docker exec -u www-data manfree_nextcloud php occ activity:list

# Export audit log
docker logs manfree_nextcloud > nextcloud-audit.log
```

---

## 📈 Monitoring

### Resource Usage

```bash
# Check Docker stats
docker stats --no-stream

# Check disk usage
docker exec manfree_nextcloud df -h

# Check database size
docker exec manfree_nextcloud_db du -sh /var/lib/mysql
```

### Active Users

```bash
# List active sessions
docker exec -u www-data manfree_nextcloud php occ user:list --output=json

# Check last login
docker exec -u www-data manfree_nextcloud php occ user:lastseen username
```

### System Logs

```bash
# View container logs
docker-compose logs -f

# View specific service
docker-compose logs -f nextcloud

# View last 100 lines
docker-compose logs --tail=100
```

---

## 🚨 Emergency Procedures

### Platform Not Responding

```bash
# 1. Check if containers are running
docker-compose ps

# 2. Restart services
docker-compose restart

# 3. If still not working, full restart
./down.sh
./up.sh
```

### Database Corruption

```bash
# 1. Stop Nextcloud
docker-compose stop nextcloud

# 2. Repair database
docker exec manfree_nextcloud_db mysqlcheck -u root -p${MYSQL_ROOT_PASSWORD} --repair --all-databases

# 3. Restart
docker-compose start nextcloud
```

### Disk Full

```bash
# 1. Check disk usage
df -h

# 2. Clean up Docker
docker system prune -a

# 3. Clean up old backups
rm backup/nextcloud-backup-OLD*.tar.gz

# 4. Clean up Nextcloud trash
docker exec -u www-data manfree_nextcloud php occ trashbin:cleanup --all-users
```

---

## 📋 Maintenance Checklist

### Weekly Checklist

- [ ] Check system status
- [ ] Review error logs
- [ ] Check disk space
- [ ] Verify backups exist
- [ ] Test restore process (monthly)
- [ ] Review user activity
- [ ] Check for updates

### Monthly Checklist

- [ ] Update Docker images
- [ ] Update Nextcloud apps
- [ ] Run database optimization
- [ ] Clean up old files
- [ ] Review security settings
- [ ] Test disaster recovery
- [ ] Review user quotas
- [ ] Check performance metrics

### Quarterly Checklist

- [ ] Full system audit
- [ ] Review access permissions
- [ ] Update documentation
- [ ] Test all integrations
- [ ] Review backup strategy
- [ ] Capacity planning
- [ ] Security assessment

---

## 📞 Support

For maintenance issues:
1. Check logs: `docker-compose logs`
2. Review this guide
3. Check TROUBLESHOOTING.md
4. Contact IT support with error details

---

**Built for Manfree Technologies Institute** ☁️
