# 🎨 Customizations Directory

**Custom apps, themes, and configurations**

---

## 📁 Directory Structure

```
customizations/
├── apps/       # Custom Nextcloud apps
├── themes/     # Custom themes
└── config/     # Custom configuration files
```

---

## 📦 Adding Custom Apps

1. Place app folder in `apps/`
2. Restart platform: `./down.sh && ./up.sh`
3. Enable via web interface or CLI:
   ```bash
   docker exec -u www-data manfree_nextcloud php occ app:enable app-name
   ```

---

## 🎨 Adding Custom Themes

1. Place theme folder in `themes/`
2. Restart platform
3. Activate via Settings → Theming

---

## ⚙️ Custom Configuration

Place custom config files in `config/` directory.

**Example:**
```php
// config/custom.config.php
<?php
$CONFIG = array(
  'custom_setting' => 'value',
);
```

---

## 🔄 Updates

Customizations are preserved during platform updates.
