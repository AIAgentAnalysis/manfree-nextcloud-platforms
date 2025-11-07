# 🔒 Security Policy

**Security guidelines for Manfree Nextcloud Platform**

---

## 🛡️ Security Features

### Built-in Protection
- ✅ Brute force protection
- ✅ Two-factor authentication (2FA)
- ✅ File encryption at rest
- ✅ HTTPS via Cloudflare tunnel
- ✅ Rate limiting
- ✅ Security headers

---

## 🔐 Best Practices

### 1. Strong Passwords

```bash
# Change default admin password immediately
# Use passwords with:
# - Minimum 12 characters
# - Mix of uppercase, lowercase, numbers, symbols
# - No dictionary words
```

### 2. Enable Two-Factor Authentication

1. Login as admin
2. Go to Settings → Security
3. Enable TOTP (Time-based One-Time Password)
4. Scan QR code with authenticator app
5. Save backup codes securely

### 3. Regular Updates

```bash
# Update Docker images monthly
docker-compose pull
./down.sh
./up.sh

# Update Nextcloud apps
docker exec -u www-data manfree_nextcloud php occ app:update --all
```

### 4. Secure Backups

```bash
# Encrypt backups before storing offsite
tar -czf - backup/ | gpg -c > backup-encrypted.tar.gz.gpg

# Store encrypted backups in multiple locations
```

### 5. Network Security

```bash
# Use firewall to restrict access
sudo ufw allow 8070/tcp  # Only from trusted networks
sudo ufw enable

# For production, use reverse proxy with SSL
```

---

## 🚨 Security Checklist

### Initial Setup
- [ ] Change default admin password
- [ ] Enable 2FA for admin account
- [ ] Configure trusted domains
- [ ] Set up HTTPS (Cloudflare tunnel)
- [ ] Review security settings
- [ ] Configure firewall rules

### Monthly Tasks
- [ ] Review user accounts
- [ ] Check security logs
- [ ] Update Docker images
- [ ] Update Nextcloud apps
- [ ] Review access permissions
- [ ] Test backup restore

### Quarterly Tasks
- [ ] Security audit
- [ ] Password policy review
- [ ] Access control review
- [ ] Penetration testing
- [ ] Disaster recovery test

---

## 🔍 Security Monitoring

### Check Security Status

```bash
# Run security scan
docker exec -u www-data manfree_nextcloud php occ security:bruteforce:reset

# Check for security warnings
# Login to web interface → Settings → Overview
```

### Review Logs

```bash
# View Nextcloud logs
docker exec manfree_nextcloud tail -f /var/www/html/data/nextcloud.log

# View failed login attempts
docker exec -u www-data manfree_nextcloud php occ security:bruteforce:attempts
```

### Monitor Access

```bash
# List active sessions
docker exec -u www-data manfree_nextcloud php occ user:list

# Check last login times
docker exec -u www-data manfree_nextcloud php occ user:lastseen username
```

---

## 🚫 Common Vulnerabilities

### 1. Weak Passwords
**Risk:** Brute force attacks
**Mitigation:** Enforce strong password policy, enable 2FA

### 2. Outdated Software
**Risk:** Known vulnerabilities
**Mitigation:** Regular updates, automated security patches

### 3. Exposed Ports
**Risk:** Unauthorized access
**Mitigation:** Use Cloudflare tunnel, configure firewall

### 4. Unencrypted Backups
**Risk:** Data exposure
**Mitigation:** Encrypt backups, secure storage

### 5. Weak Access Controls
**Risk:** Privilege escalation
**Mitigation:** Principle of least privilege, regular audits

---

## 📋 Incident Response

### If Security Breach Suspected

1. **Immediate Actions:**
   ```bash
   # Put site in maintenance mode
   docker exec -u www-data manfree_nextcloud php occ maintenance:mode --on
   
   # Review logs
   docker-compose logs > incident-logs.txt
   
   # Check active sessions
   docker exec -u www-data manfree_nextcloud php occ user:list
   ```

2. **Investigation:**
   - Review access logs
   - Check file modifications
   - Identify compromised accounts
   - Document timeline

3. **Remediation:**
   ```bash
   # Reset affected passwords
   docker exec -u www-data manfree_nextcloud php occ user:resetpassword username
   
   # Revoke sessions
   docker exec -u www-data manfree_nextcloud php occ user:delete-sessions username
   
   # Update system
   docker-compose pull
   ./down.sh
   ./up.sh
   ```

4. **Recovery:**
   - Restore from clean backup if needed
   - Implement additional security measures
   - Monitor for further suspicious activity

---

## 📞 Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email: security@manfreetechnologies.com
3. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

---

## 🔗 Security Resources

- [Nextcloud Security](https://nextcloud.com/security/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)

---

**Security is everyone's responsibility** 🛡️

*Last updated: October 2025*
