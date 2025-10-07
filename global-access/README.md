# 🌍 Global Access Solutions

**Access Nextcloud from anywhere on the internet**

---

## 📁 Directory Structure

```
global-access/
├── permanent/    # Cloudflare Tunnel (recommended)
└── temporary/    # Quick tunnels (ngrok, bore, etc.)
```

---

## 🔒 Permanent Solution (Recommended)

**Cloudflare Tunnel:**
- Domain: files.manfreetechnologies.com
- HTTPS automatic
- Free tier available
- Auto-start on boot

**Setup:**
```bash
cd permanent/
./setup.sh
```

See `permanent/README.md` for detailed instructions.

---

## ⚡ Temporary Solutions

**Quick tunnels for testing:**
- ngrok
- bore
- localtunnel
- pinggy
- serveo

**Usage:**
```bash
cd temporary/
./ngrok-tunnel.sh
```

See `temporary/README.md` for all options.

---

## 🎯 Which to Use?

**Use Permanent (Cloudflare) if:**
- Need 24/7 access
- Want custom domain
- Need HTTPS
- Production use

**Use Temporary if:**
- Testing only
- One-time demo
- Quick sharing
- No domain needed

---

## 📞 Support

See individual README files in each directory for detailed setup instructions.
