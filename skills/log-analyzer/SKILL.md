---
name: log-analyzer
description: 日志分析工具 - 实时分析日志文件，支持错误统计、模式识别、异常检测、可视化报告生成。
---

# Log Analyzer

日志文件实时分析工具，帮助快速定位问题。

## 功能

- 📊 错误/警告统计
- 🔍 模式匹配和聚合
- 🚨 异常检测
- 📈 可视化报告
- ⏰ 实时监控模式
- 📋 日志搜索和过滤
- 🏷️ 自定义规则

## 使用方法

### 基础分析

```bash
# 分析日志文件
log-analyze /var/log/system.log

# 指定行数
log-analyze /var/log/system.log -n 1000

# 统计错误
log-analyze /var/log/system.log --errors

# 统计警告
log-analyze /var/log/system.log --warnings
```

### 搜索

```bash
# 搜索关键词
log-analyze /var/log/system.log -s "error"

# 正则搜索
log-analyze /var/log/system.log -s "Failed.*password" -r

# 多关键词
log-analyze /var/log/system.log -s "error" -s "warning"
```

### 时间范围

```bash
# 最近 1 小时
log-analyze /var/log/system.log --since "1h"

# 指定时间段
log-analyze /var/log/system.log --from "2026-02-23 10:00" --to "2026-02-23 11:00"

# 今天
log-analyze /var/log/system.log --today
```

### 实时监控

```bash
# 实时监控日志
log-analyze /var/log/system.log --watch

# 只显示错误
log-analyze /var/log/system.log --watch --errors
```

### 报告生成

```bash
# 生成 HTML 报告
log-analyze /var/log/system.log --report report.html

# 生成 JSON 统计
log-analyze /var/log/system.log --json > stats.json

# 邮件报告
log-analyze /var/log/system.log --email admin@example.com
```

## 统计输出示例

```
$ log-analyze app.log --stats

📊 日志分析报告: app.log
═══════════════════════════════════════════

📁 文件: app.log
📏 大小: 2.3 MB
📋 总行数: 45,231
⏱️ 时间范围: 2026-02-22 00:00 - 2026-02-23 00:00

🚨 错误 (ERROR): 127
⚠️  警告 (WARN):  89
ℹ️  信息 (INFO):  4,521
🔧 调试 (DEBUG): 40,494

🔥 Top 5 错误:
  1. Connection timeout    45次  (35%)
  2. NullPointerException 32次  (25%)
  3. File not found       21次  (16%)
  4. Auth failed          15次  (12%)
  5. Database error       14次  (11%)

📈 每小时错误分布:
  00:00 ▓▓▓▓▓ 12
  01:00 ▓▓▓▓   8
  02:00 ▓▓▓    5
  ...
```

## 自定义规则

创建 `~/.log-analyzer/rules.json`:

```json
{
  "rules": [
    {
      "name": "Database Errors",
      "pattern": "SQL.*Error",
      "level": "error",
      "alert": true
    },
    {
      "name": "Slow Response",
      "pattern": "response_time>\\d+",
      "level": "warning",
      "threshold": 1000
    }
  ]
}
```

## 与 OpenClaw 集成

```json
{
  "name": "Daily Log Report",
  "schedule": { "kind": "cron", "expr": "0 8 * * *" },
  "payload": {
    "kind": "systemEvent",
    "text": "Analyze logs: log-analyze ~/logs/app.log --report ~/logs/report.html --email you@example.com"
  }
}
```

## 支持的日志格式

- Syslog
- Apache/Nginx access log
- JSON logs
- Application logs (自定义格式)
- CloudWatch logs
- Kubernetes logs

## 常用命令快捷

```bash
# 查看错误
alias logs-errors='log-analyze ~/logs/app.log --errors'

# 实时监控错误
alias logs-watch='log-analyze ~/logs/app.log --watch --errors'

# 今日报告
alias logs-today='log-analyze ~/logs/app.log --today --report ~/logs/today.html'
```

## 注意事项

1. 大文件建议先 `tail` 再分析
2. JSON 日志自动解析
3. 支持压缩日志 (.gz)
4. 可配置通知渠道
