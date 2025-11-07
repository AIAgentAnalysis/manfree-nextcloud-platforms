# 🔧 Troubleshooting Guide

**Common issues and solutions**

---

## 🚨 CRITICAL: Cannot Stop Containers (Permission Denied)

**Symptoms:**
```bash
$ docker-compose down
Error response from daemon: cannot stop container: permission denied
```

**Root Cause:**
Docker daemon state corruption from stuck container processes.

**Solution:**
```bash
# Run the fix script
./fix-docker.sh

# Then rebuild and start
docker-compose build --no-cache
docker-compose up -d
```

**Details:** See [DOCKER-SHUTDOWN-ISSUE.md](../DOCKER-SHUTDOWN-ISSUE.md) for complete analysis.

---

## 🚨 Platform Won't Start

**Check Docker:**
```bash
docker ps -a
docker-compose logs
```

**Solution:**
```bash
docker-compose down
docker-compose up -d --build
```

---

## 🔐 Can't Login

**Reset Admin Password:**
```bash
docker exec -u www-data manfree_nextcloud php occ user:resetpassword admin
```

**Check Trusted Domains:**
```bash
docker exec manfree_nextcloud cat /var/www/html/config/config.php | grep trusted_domains
```

---

## 🌐 LAN Access Not Working

**Check Firewall:**
```bash
sudo ufw allow 8070
```

**Update Trusted Domains:**
```bash
# Edit .env file
nano .env
# Add your IP to NEXTCLOUD_TRUSTED_DOMAINS
# Restart: ./down.sh && ./up.sh
```

---

## 📁 File Upload Fails

**Check PHP Settings:**
```bash
docker exec manfree_nextcloud php -i | grep upload_max_filesize
```

**Check Disk Space:**
```bash
df -h
```

---

## 🐌 Slow Performance

**Check Redis:**
```bash
docker exec manfree_nextcloud_redis redis-cli ping
```

**Run Maintenance:**
```bash
docker exec -u www-data manfree_nextcloud php occ maintenance:repair
docker exec -u www-data manfree_nextcloud php occ db:add-missing-indices
```

---

## 💾 Backup Issues

**Manual Backup:**
```bash
./auto-backup.sh
```

**Check Backup Integrity:**
```bash
ls -la backup/
tar -tzf backup/nextcloud-backup-*_nextcloud_data.tar.gz | head
```

---

## 🔄 Complete Reset

**⚠️ WARNING: Deletes all data**

```bash
docker-compose down
docker volume prune -f
./up.sh
```

---

## 📞 Getting Help

**Collect Information:**
```bash
docker-compose ps
docker-compose logs --tail=50
docker stats --no-stream
```

Contact support with logs and error messages.
