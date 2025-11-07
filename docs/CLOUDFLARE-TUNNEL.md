# 🌐 Cloudflare Tunnel Setup Guide

**Global Access for Nextcloud Platform**

---

## 📋 Overview

Cloudflare Tunnel provides secure global access to your Nextcloud instance without opening firewall ports or exposing your server's IP address.

**Benefits:**
- ✅ HTTPS encryption automatically
- ✅ No port forwarding needed
- ✅ DDoS protection included
- ✅ Free for personal use
- ✅ Custom domain support

---

## 🚀 Quick Setup

### Prerequisites
- Cloudflare account (free)
- Domain managed by Cloudflare
- Nextcloud running locally

### Step 1: Install cloudflared

```bash
# Ubuntu/Debian
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update && sudo apt-get install -y cloudflared
```

### Step 2: Authenticate

```bash
cloudflared tunnel login
```

This opens a browser to authenticate with Cloudflare.

### Step 3: Create Tunnel

```bash
cloudflared tunnel create nextcloud
```

### Step 4: Configure Tunnel

```bash
# Create config file
cat > ~/.cloudflared/config.yml << 'EOF'
tunnel: YOUR-TUNNEL-ID
credentials-file: /home/YOUR-USERNAME/.cloudflared/YOUR-TUNNEL-ID.json

ingress:
  - hostname: cloud.manfreetechnologies.com
    service: http://localhost:8070
  - service: http_status:404
EOF
```

### Step 5: Route DNS

```bash
cloudflared tunnel route dns nextcloud cloud.manfreetechnologies.com
```

### Step 6: Install Service

```bash
sudo cloudflared --config ~/.cloudflared/config.yml service install
sudo systemctl start cloudflared
sudo systemctl enable cloudflared
```

---

## ✅ Verification

```bash
# Check tunnel status
cloudflared tunnel list

# Check service status
sudo systemctl status cloudflared

# Test access
curl -I https://cloud.manfreetechnologies.com
```

---

## 🔧 Management Commands

```bash
# Start tunnel
sudo systemctl start cloudflared

# Stop tunnel
sudo systemctl stop cloudflared

# Restart tunnel
sudo systemctl restart cloudflared

# View logs
journalctl -u cloudflared -f

# Check tunnel info
cloudflared tunnel info nextcloud
```

---

## 🛠️ Troubleshooting

### Tunnel Not Connecting

```bash
# Check if service is running
sudo systemctl status cloudflared

# View recent logs
journalctl -u cloudflared -n 50

# Test local Nextcloud
curl -I http://localhost:8070
```

### DNS Not Resolving

```bash
# Check DNS record
nslookup cloud.manfreetechnologies.com

# Verify tunnel route
cloudflared tunnel route dns list
```

### Error 1033

This means DNS is pointing to wrong tunnel. Update DNS:

```bash
# Delete old route
cloudflared tunnel route dns delete cloud.manfreetechnologies.com

# Add new route
cloudflared tunnel route dns nextcloud cloud.manfreetechnologies.com
```

---

## 🔒 Security Considerations

### Trusted Domains

Add your domain to Nextcloud trusted domains:

```bash
docker exec -u www-data manfree_nextcloud php occ config:system:set trusted_domains 1 --value=cloud.manfreetechnologies.com
```

### HTTPS Configuration

```bash
docker exec -u www-data manfree_nextcloud php occ config:system:set overwriteprotocol --value=https
```

---

## 📊 Monitoring

### Check Tunnel Health

```bash
# View active connections
cloudflared tunnel list

# Check metrics
curl http://localhost:20241/metrics
```

### Performance Metrics

- **Latency:** Typically 50-100ms added
- **Bandwidth:** No limits on free tier
- **Uptime:** 99.9%+ with Cloudflare

---

## 🔄 Auto-Start on Boot

The tunnel service is configured to start automatically on system boot. To verify:

```bash
# Check if enabled
systemctl is-enabled cloudflared

# Enable if not
sudo systemctl enable cloudflared
```

---

## 🌍 Multiple Domains

You can route multiple domains to different services:

```yaml
ingress:
  - hostname: cloud.manfreetechnologies.com
    service: http://localhost:8070
  - hostname: cloud.manfreetechnologies.com
    service: http://localhost:8070
  - service: http_status:404
```

---

## 📞 Support

For issues:
1. Check logs: `journalctl -u cloudflared -n 100`
2. Verify config: `cat ~/.cloudflared/config.yml`
3. Test locally: `curl http://localhost:8070`
4. Check Cloudflare dashboard for DNS settings

---

**Built for Manfree Technologies Institute** ☁️
