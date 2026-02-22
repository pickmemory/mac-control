---
name: site-monitor
description: 网站监控工具 - 监控网站可用性、响应时间、SSL证书、关键词检测，支持邮件/Slack/Discord告警。
---

# Site Monitor

网站/服务监控工具，支持可用性、性能、SSL 监控。

## 功能

- 🌐 HTTP/HTTPS 监控
- ⏱️ 响应时间追踪
- 🔒 SSL 证书监控
- 🔍 关键词检测
- 📊 性能图表
- 📧 多渠道告警 (Email, Slack, Discord, Telegram)
- 📋 历史记录
- 🔄 自动重试
- 📱 移动端检测

## 使用方法

### 添加监控

```bash
# 基础监控
site-monitor add https://example.com

# 带告警
site-monitor add https://example.com --alert

# 自定义检查
site-monitor add https://example.com \
  --expected-status 200 \
  --timeout 10 \
  --keywords "Welcome,Login"
```

### 监控列表

```bash
# 查看所有监控
site-monitor list

# 查看具体站点
site-monitor status example.com
```

### 手动检查

```bash
# 检查站点
site-monitor check example.com

# 详细输出
site-monitor check example.com --verbose
```

### SSL 证书检查

```bash
# 检查 SSL
site-monitor ssl example.com

# 查看所有 SSL 状态
site-monitor ssl --all
```

## 配置文件

创建 `~/.site-monitor/config.json`:

```json
{
  "sites": [
    {
      "name": "My Blog",
      "url": "https://myblog.com",
      "interval": 300,
      "timeout": 10,
      "expected_status": 200,
      "keywords": ["Welcome"],
      "alert": {
        "enabled": true,
        "channels": ["email", "slack"],
        "retry": 3
      }
    },
    {
      "name": "API",
      "url": "https://api.myapp.com/health",
      "interval": 60,
      "timeout": 5
    }
  ],
  "alerts": {
    "email": {
      "enabled": true,
      "to": "you@example.com",
      "smtp": "smtp.gmail.com"
    },
    "slack": {
      "enabled": true,
      "webhook": "https://hooks.slack.com/..."
    },
    "discord": {
      "enabled": true,
      "webhook": "https://discord.com/api/webhooks/..."
    }
  }
}
```

### 设置定时任务

```bash
# 安装监控 cron
site-monitor install

# 查看状态
site-monitor status
```

## 告警规则

```bash
# 响应时间告警 (> 2s)
site-monitor add https://api.example.com --alert-on-slow 2000

# 状态码变化告警
site-monitor add https://api.example.com --alert-on-status-change

# 关键词消失告警
site-monitor add https://example.com --alert-on-missing "Welcome"

# SSL 过期告警 (30天内)
site-monitor add https://example.com --alert-on-ssl-expiry 30
```

## 报告生成

```bash
# 日报
site-monitor report --daily --output report.html

# 周报
site-monitor report --weekly --email you@example.com

# 可用性统计
site-monitor stats example.com --period 30d
```

## 输出示例

```
$ site-monitor check myblog.com

✅ myblog.com - OK
   Status: 200
   Time: 1.23s
   SSL: Valid (expires in 89 days)
   Keywords: ✅ All found

$ site-monitor check api.example.com

❌ api.example.com - DOWN
   Status: 503
   Time: 5.42s
   Error: Service Unavailable
   Retry 1/3...
   Retry 2/3...
   Still down after 3 retries

📧 Alert sent to: you@example.com, #alerts
```

## 与 OpenClaw 集成

```json
{
  "name": "Site Health Check",
  "schedule": { "kind": "every", "everyMs": 300000 },
  "payload": {
    "kind": "systemEvent",
    "text": "Run site check: site-monitor check all"
  }
}
```

## 常用命令

```bash
# 批量检查
site-monitor check-all

# 查看历史
site-monitor history mysite.com

# 导出数据
site-monitor export --format csv

# 性能图表
site-monitor chart mysite.com --days 7
```

## 性能基准

```
响应时间分级:
🟢 < 500ms  - Excellent
🟡 < 1s     - Good  
🟠 < 2s     - Acceptable
🔴 > 2s     - Slow

可用性分级:
🟢 > 99.9%  - Excellent
🟡 > 99%    - Good
🟠 > 95%    - Acceptable
🔴 < 95%    - Critical
```

## 注意事项

1. 合理设置检查间隔 (建议 ≥ 60s)
2. 告警需要配置通知渠道
3. 大量站点注意 API 限制
4. SSL 检查默认启用
5. 历史数据默认保留 30 天
