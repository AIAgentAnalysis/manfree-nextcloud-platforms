# 🔒 Cloudflare Tunnel - Permanent Global Access

**Setup permanent HTTPS access with custom domain**

---

## 🎯 What You Get

- **Domain**: cloud.manfreetechnologies.com
- **HTTPS**: Automatic SSL certificates
- **Always On**: Auto-start on system boot
- **Free**: Cloudflare free tier

---

## 📋 Prerequisites

1. Cloudflare account (free)
2. Domain name (can use Cloudflare's free subdomain)
3. Ubuntu/Linux system

---

## 🚀 Quick Setup

```bash
# Run setup script
./setup.sh

# Follow prompts to:
# 1. Install cloudflared
# 2. Login to Cloudflare
# 3. Create tunnel
# 4. Configure domain
# 5. Setup auto-start
```

---

## 📝 Manual Setup

### 1. Install cloudflared

```bash
# Ubuntu/Debian
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

### 2. Login to Cloudflare

```bash
cloudflared tunnel login
```

### 3. Create Tunnel

```bash
cloudflared tunnel create manfree-nextcloud
```

### 4. Configure Tunnel

Create `~/.cloudflared/config.yml`:
```yaml
tunnel: manfree-nextcloud
credentials-file: /home/USER/.cloudflared/TUNNEL-ID.json

ingress:
  - hostname: cloud.manfreetechnologies.com
    service: http://localhost:8090
  - service: http_status:404
```

### 5. Route DNS

```bash
cloudflared tunnel route dns manfree-nextcloud cloud.manfreetechnologies.com
```

### 6. Setup Auto-Start

```bash
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## ✅ Verify Setup

```bash
# Check tunnel status
sudo systemctl status cloudflared

# Test access
curl https://cloud.manfreetechnologies.com
```

---

## 🔧 Management

**Start tunnel:**
```bash
sudo systemctl start cloudflared
```

**Stop tunnel:**
```bash
sudo systemctl stop cloudflared
```

**Check logs:**
```bash
sudo journalctl -u cloudflared -f
```

---

## 📞 Support

See CONSOLIDATED-GUIDE.md for detailed instructions.
