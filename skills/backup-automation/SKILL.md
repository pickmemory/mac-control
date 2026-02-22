---
name: backup-automation
description: 自动化备份工具 - 定时备份文件/数据库，支持增量备份、加密、压缩、多目标存储（本地/云）。
---

# Backup Automation

自动化备份工具，支持文件、数据库定时备份。

## 功能

- 📁 文件夹备份
- 🗄️ 数据库备份 (MySQL, PostgreSQL, MongoDB)
- 🔐 AES-256 加密
- 📦 压缩 (tar.gz, zip)
- ☁️ 多目标存储 (本地, S3, Google Drive, Dropbox)
- 📊 增量备份
- 🔄 自动清理旧备份
- 📋 备份验证
- 📧 邮件通知

## 使用方法

### 文件备份

```bash
# 备份文件夹
backup.sh --source ~/Documents --destination ~/Backups/documents

# 压缩备份
backup.sh --source ~/Documents --destination ~/Backups/documents --compress

# 加密备份
backup.sh --source ~/Documents --destination ~/Backups/documents --encrypt --password mypass
```

### 数据库备份

```bash
# MySQL
backup.sh --type mysql --database myapp --destination ~/Backups/mysql

# PostgreSQL  
backup.sh --type postgres --database myapp --destination ~/Backups/postgres

# MongoDB
backup.sh --type mongo --database myapp --destination ~/Backups/mongo
```

### 增量备份

```bash
# 首次全量
backup.sh --source ~/Data --destination ~/Backups/data --full

# 后续增量
backup.sh --source ~/Data --destination ~/Backups/data --incremental
```

### 云端备份

```bash
# 备份到 S3
backup.sh --source ~/Data --destination s3://my-bucket/backups --encrypt

# 备份到 Google Drive
backup.sh --source ~/Data --destination gdrive://backups/myapp
```

## 配置文件

创建 `~/.backup/config.json`:

```json
{
  "jobs": [
    {
      "name": "Documents Daily",
      "source": "~/Documents",
      "destination": "~/Backups/documents",
      "schedule": "0 2 * * *",
      "compress": true,
      "encrypt": false,
      "retention": 7
    },
    {
      "name": "Database Hourly",
      "type": "mysql",
      "database": "myapp",
      "destination": "s3://my-bucket/db",
      "schedule": "0 * * * *",
      "compress": true,
      "encrypt": true,
      "retention": 24
    }
  ],
  "notifications": {
    "email": "you@example.com",
    "on_success": false,
    "on_failure": true
  }
}
```

### 备份计划

```bash
# 添加定时任务
backup.sh --install-cron

# 查看所有备份任务
backup.sh --list

# 手动运行任务
backup.sh --run "Documents Daily"
```

## 备份策略

### 3-2-1 原则
- 3 份副本
- 2 种不同介质
- 1 份异地

```bash
# 示例: 3-2-1 备份
backup.sh --source ~/Data \
  --destination ~/Backups/local \
  --destination /external/hdd \
  --destination s3://my-backup-bucket
```

### 保留策略

```bash
# 保留 7 个每日备份
# 保留 4 个每周备份
# 保留 6 个每月备份
backup.sh --source ~/Data --destination ~/Backups \
  --retention-daily 7 \
  --retention-weekly 4 \
  --retention-monthly 6
```

## 验证与恢复

```bash
# 验证备份完整性
backup.sh --verify ~/Backups/documents_2026-02-22.tar.gz

# 列出备份内容
backup.sh --list-contents ~/Backups/documents_2026-02-22.tar.gz

# 解压恢复
backup.sh --restore ~/Backups/documents_2026-02-22.tar.gz --to ~/Restored
```

## 与 OpenClaw 集成

```json
{
  "name": "Daily Backup",
  "schedule": { "kind": "cron", "expr": "0 2 * * *" },
  "payload": {
    "kind": "systemEvent",
    "text": "Run backup: backup.sh --run 'Documents Daily'"
  }
}
```

## 状态检查

```bash
# 查看备份状态
backup.sh --status

# 查看最近备份
backup.sh --recent

# 磁盘使用情况
backup.sh --disk-usage
```

## 输出示例

```
$ backup.sh --source ~/Documents --destination ~/Backups/documents --compress

📦 Starting backup...
📁 Source: /Users/heyi/Documents
📍 Destination: /Users/heyi/Backups/documents
📦 Compression: enabled

🔄 Creating archive...
✅ Archive created: documents_20260223_020000.tar.gz (145 MB)

🧹 Cleaning old backups (retention: 7)...
✅ Removed: documents_20260216_020000.tar.gz

📊 Backup complete!
   Size: 145 MB
   Time: 23s
   Files: 1,234
```

## 注意事项

1. 首次备份可能较慢
2. 加密需要设置密码环境变量
3. 云存储需要配置凭证
4. 建议先测试恢复流程
5. 监控磁盘空间
