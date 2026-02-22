---
name: social-post-scheduler
description: 社交媒体定时发布工具 - 支持定时发布到 Twitter、Mastodon、LinkedIn 等平台。支持草稿保存、定时发布、发布统计。
---

# Social Post Scheduler

社交媒体定时发布工具，支持多平台定时发布。

## 支持平台

- 🐦 Twitter / X
- 🦋 Mastodon
- 💼 LinkedIn
- 📝 文本帖子

## 功能

- ⏰ 定时发布（支持 cron 表达式）
- 📝 草稿保存
- 📊 发布统计
- 🔄 自动重试
- 📋 多平台同时发布

## 使用方法

### 创建帖子

```bash
# 创建新帖子（交互式）
~/.openclaw/workspace/skills/social-post-scheduler/create-post.sh

# 指定内容和时间
~/.openclaw/workspace/skills/social-post-scheduler/schedule.sh \
    --content "Hello World!" \
    --time "2026-02-23 10:00:00" \
    --platforms twitter,mastodon
```

### 查看待发布

```bash
# 查看所有待发布帖子
cat ~/.social_posts/pending.json | jq '.'

# 查看已发布
cat ~/.social_posts/published.json | jq '.'
```

### 管理帖子

```bash
# 删除草稿
~/.openclaw/workspace/skills/social-post-scheduler/delete-post.sh <post_id>

# 立即发布
~/.openclaw/workspace/skills/social-post-scheduler/publish-now.sh <post_id>
```

## 定时发布配置

```bash
# 每天早上9点自动发布
crontab -e
# 添加: 0 9 * * * ~/.openclaw/workspace/skills/social-post-scheduler/daily-poster.sh
```

## 脚本结构

```
social-post-scheduler/
├── create-post.sh      # 创建新帖子
├── schedule.sh         # 定时发布
├── publish-now.sh      # 立即发布
├── delete-post.sh      # 删除帖子
├── daily-poster.sh     # 每日自动发布
├── platforms/
│   ├── twitter.sh      # Twitter API
│   ├── mastodon.sh     # Mastodon API
│   └── linkedin.sh     # LinkedIn API
└── storage/
    ├── pending.json    # 待发布
    ├── published.json  # 已发布
    └── drafts.json     # 草稿
```

## 环境配置

需要设置以下环境变量：

```bash
# Twitter
export TWITTER_API_KEY="your_api_key"
export TWITTER_API_SECRET="your_api_secret"
export TWITTER_ACCESS_TOKEN="your_access_token"
export TWITTER_ACCESS_SECRET="your_access_secret"

# Mastodon
export MASTODON_INSTANCE="mastodon.social"
export MASTODON_TOKEN="your_access_token"

# LinkedIn
export LINKEDIN_TOKEN="your_access_token"
```

## 与 OpenClaw 集成

可以在 OpenClaw 中创建定时任务：

```json
{
  "name": "Daily Social Post",
  "schedule": { "kind": "cron", "expr": "0 9 * * *" },
  "payload": { 
    "kind": "agentTurn", 
    "message": "Post a motivational quote to Twitter and Mastodon" 
  }
}
```

## 注意事项

1. 需要先配置各平台 API 密钥
2. 遵守各平台 API 限制
3. 建议使用草稿功能先预览
4. 注意时区设置
