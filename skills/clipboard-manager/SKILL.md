---
name: clipboard-manager
description: 剪贴板管理器 - 记录、搜索、管理剪贴板历史。支持文本、图片、文件路径，最多保存100条历史记录，支持关键词搜索。
---

# Clipboard Manager

Mac 剪贴板增强工具，记录剪贴板历史并支持搜索。

## 功能

- 📋 自动记录剪贴板历史（文本、图片、文件路径）
- 🔍 关键词搜索历史记录
- 📁 支持文件路径记录
- 🖼️ 支持图片剪贴板
- 🗑️ 清理历史记录
- ⭐ 收藏重要条目

## 使用方法

### 记录剪贴板
```bash
# 查看当前剪贴板内容
pbpaste

# 手动添加记录
echo "内容" | pbcopy
```

### 搜索剪贴板历史
```bash
# 搜索包含关键词的记录
grep -i "关键词" ~/.clipboard_history.json
```

### 查看历史
```bash
# 查看最近10条
tail -10 ~/.clipboard_history.json
```

## 数据存储

- 位置: `~/.clipboard_history.json`
- 格式: JSON Lines (每行一条记录)
- 最大条数: 100条（自动清理旧记录）
- 包含: 文本内容、时间戳、类型

## 自动监控脚本

创建一个后台进程监控剪贴板变化：

```bash
#!/bin/bash
HISTORY_FILE="$HOME/.clipboard_history.json"
MAX_ENTRIES=100

# 监控剪贴板变化
while true; do
    # 获取当前剪贴板内容
    CONTENT=$(pbpaste 2>/dev/null)
    
    if [ -n "$CONTENT" ]; then
        # 检查是否与最后一条相同
        LAST_CONTENT=$(tail -1 "$HISTORY_FILE" 2>/dev/null | jq -r '.content // ""')
        
        if [ "$CONTENT" != "$LAST_CONTENT" ]; then
            # 添加新记录
            TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            echo "{\"timestamp\":\"$TIMESTAMP\",\"content\":\"$(echo "$CONTENT" | jq -Rs .)\",\"type\":\"text\"}" >> "$HISTORY_FILE"
            
            # 保持最多100条
            if [ $(wc -l < "$HISTORY_FILE") -gt $MAX_ENTRIES ]; then
                tail -n $MAX_ENTRIES "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
                mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
            fi
        fi
    fi
    
    sleep 1
done
```

## 与 OpenClaw 集成

可以在 OpenClaw 中调用：

1. 读取剪贴板历史
2. 搜索特定内容
3. 恢复之前的剪贴板内容

## 实用命令

```bash
# 启动监控（后台运行）
nohup /path/to/monitor_clipboard.sh &

# 搜索特定关键词
jq -r '.content' ~/.clipboard_history.json | grep -i "关键词"

# 统计每日复制次数
jq -r '.timestamp[:10]' ~/.clipboard_history.json | sort | uniq -c

# 查看最近5条
tail -5 ~/.clipboard_history.json | jq -c '.'

# 清空历史
> ~/.clipboard_history.json
```
