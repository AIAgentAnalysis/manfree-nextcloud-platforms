# 💾 Backup Directory

**Automatic backups stored here**

---

## 📦 Backup Files

Backups are created automatically when running `./down.sh` or manually with `./auto-backup.sh`.

**File naming:**
```
nextcloud-backup-YYYYMMDD_HHMMSS_nextcloud_data.tar.gz
nextcloud-backup-YYYYMMDD_HHMMSS_nextcloud_files.tar.gz
nextcloud-backup-YYYYMMDD_HHMMSS_nextcloud_config.tar.gz
nextcloud-backup-YYYYMMDD_HHMMSS_mariadb_data.tar.gz
```

---

## 🔄 Restore Backup

```bash
# Restore latest backup
./auto-restore.sh

# Then start platform
./up.sh
```

---

## 🧹 Cleanup

**Automatic:** Keeps only last 3 backups

**Manual cleanup:**
```bash
# Remove old backups
rm backup/nextcloud-backup-20250101_*
```

---

## 📊 Check Backup Size

```bash
du -sh backup/*
```

---

## ⚠️ Git LFS

For backups >90MB, use Git LFS:
```bash
git lfs install
git lfs track "*.tar.gz"
```
