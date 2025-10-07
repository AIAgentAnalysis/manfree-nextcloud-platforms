# ⚡ Temporary Tunnels - Quick Global Access

**Quick tunnels for testing and demos**

---

## 🎯 Available Solutions

| Tool | Command | Features |
|------|---------|----------|
| **ngrok** | `./ngrok-tunnel.sh` | Most popular, free tier |
| **bore** | `./bore-tunnel.sh` | Simple, no signup |
| **localtunnel** | `./localtunnel.sh` | Free, custom subdomain |
| **pinggy** | `./pinggy-tunnel.sh` | No install needed |
| **serveo** | `./serveo-tunnel.sh` | SSH-based |

---

## 🚀 Quick Start

### ngrok (Recommended)

```bash
# Install
sudo snap install ngrok

# Run tunnel
./ngrok-tunnel.sh

# Get URL from output
# Example: https://abc123.ngrok.io
```

### bore

```bash
# Install
cargo install bore-cli

# Run tunnel
./bore-tunnel.sh
```

### localtunnel

```bash
# Install
npm install -g localtunnel

# Run tunnel
./localtunnel.sh
```

---

## ⚠️ Limitations

**Temporary tunnels:**
- URL changes on restart
- May have bandwidth limits
- Not for production
- Session timeouts

**Use permanent tunnel (Cloudflare) for production**

---

## 📝 Usage

1. Start Nextcloud: `./up.sh`
2. Run tunnel script
3. Copy URL from output
4. Share URL with users
5. Stop tunnel when done (Ctrl+C)

---

## 📞 Support

See individual script files for detailed usage.
