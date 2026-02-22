---
name: auto-file-organizer
description: 自动文件整理工具 - 定时整理 Downloads 文件夹，按文件类型自动分类到对应文件夹。支持图片、文档、压缩包、安装包等。
---

# Auto File Organizer

macOS 自动文件整理工具，将 Downloads 文件夹中的文件按类型自动分类。

## 功能

- 📂 按文件类型自动分类（图片、文档、压缩包、安装包、视频、音频）
- ⏰ 可设置定时运行（每小时/每天）
- 🔄 移动或复制模式可选
- 📋 保留文件操作日志
- ⚙️ 可自定义分类规则

## 文件类型映射

| 类型 | 扩展名 | 目标文件夹 |
|------|--------|-----------|
| 图片 | .jpg, .jpeg, .png, .gif, .webp, .svg, .bmp, .tiff | ~/Pictures/Sorted |
| 文档 | .pdf, .doc, .docx, .xls, .xlsx, .ppt, .pptx, .txt, .md | ~/Documents/Sorted |
| 压缩包 | .zip, .rar, .7z, .tar, .gz | ~/Documents/Archives |
| 安装包 | .dmg, .pkg, .exe, .deb, .rpm | ~/Applications/Installers |
| 视频 | .mp4, .mov, .avi, .mkv, .webm | ~/Movies/Sorted |
| 音频 | .mp3, .wav, .flac, .aac, .m4a | ~/Music/Sorted |
| 代码 | .js, .ts, .py, .java, .cpp, .c, .h, .go, .rs | ~/Documents/Code |
| 其他 | 其他所有文件 | ~/Downloads/Unsorted |

## 使用方法

### 基本用法

```bash
# 整理 Downloads 文件夹
~/.openclaw/workspace/skills/auto-file-organizer/organize.sh

# 预览模式（只显示不移动）
~/.openclaw/workspace/skills/auto-file-organizer/organize.sh --preview

# 移动模式（默认是复制）
~/.openclaw/workspace/skills/auto-file-organizer/organize.sh --move
```

### 设置定时任务

```bash
# 每天凌晨3点自动整理
crontab -e
# 添加: 0 3 * * * ~/.openclaw/workspace/skills/auto-file-organizer/organize.sh

# 每小时整理
# 添加: 0 * * * * ~/.openclaw/workspace/skills/auto-file-organizer/organize.sh
```

## 脚本代码

```bash
#!/bin/bash

# Auto File Organizer for macOS
# 按文件类型自动整理 Downloads 文件夹

DOWNLOADS_DIR="$HOME/Downloads"
LOG_FILE="$HOME/.file_organizer.log"
PREVIEW_MODE=false
MOVE_MODE=false

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --preview)
            PREVIEW_MODE=true
            shift
            ;;
        --move)
            MOVE_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# 分类函数
organize_file() {
    local file="$1"
    local filename=$(basename "$file")
    local ext="${filename##*.}"
    local ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    
    local dest_dir=""
    
    case "$ext_lower" in
        jpg|jpeg|png|gif|webp|svg|bmp|tiff|heic)
            dest_dir="$HOME/Pictures/Sorted"
            ;;
        pdf|doc|docx|xls|xlsx|ppt|pptx|txt|md|rtf|odt|ods)
            dest_dir="$HOME/Documents/Sorted"
            ;;
        zip|rar|7z|tar|gz|bz2|xz)
            dest_dir="$HOME/Documents/Archives"
            ;;
        dmg|pkg|exe|deb|rpm|app)
            dest_dir="$HOME/Applications/Installers"
            ;;
        mp4|mov|avi|mkv|webm|flv|wmv)
            dest_dir="$HOME/Movies/Sorted"
            ;;
        mp3|wav|flac|aac|m4a|ogg|wma)
            dest_dir="$HOME/Music/Sorted"
            ;;
        js|ts|py|java|cpp|c|h|go|rs|rb|php|html|css|json|xml|yaml|yml|sh)
            dest_dir="$HOME/Documents/Code"
            ;;
        *)
            dest_dir="$DOWNLOADS_DIR/Unsorted"
            ;;
    esac
    
    # 创建目标目录
    mkdir -p "$dest_dir"
    
    # 目标路径
    local dest_file="$dest_dir/$filename"
    
    # 处理文件名冲突
    if [ -e "$dest_file" ]; then
        local base="${filename%.*}"
        local counter=1
        while [ -e "$dest_dir/${base}_${counter}.${ext}" ]; do
            ((counter++))
        done
        dest_file="$dest_dir/${base}_${counter}.${ext}"
    fi
    
    # 执行移动或复制
    if [ "$PREVIEW_MODE" = true ]; then
        echo "[PREVIEW] $filename -> $dest_dir"
    else
        if [ "$MOVE_MODE" = true ]; then
            mv "$file" "$dest_file"
            echo "$(date '+%Y-%m-%d %H:%M:%S') [MOVE] $filename -> $dest_dir" >> "$LOG_FILE"
        else
            cp "$file" "$dest_file"
            echo "$(date '+%Y-%m-%d %H:%M:%S') [COPY] $filename -> $dest_dir" >> "$LOG_FILE"
        fi
    fi
}

# 主逻辑
echo "Starting file organization..."
echo "Downloads: $DOWNLOADS_DIR"
echo "Mode: $(if [ "$PREVIEW_MODE" = true ]; then echo "PREVIEW"; elif [ "$MOVE_MODE" = true ]; then echo "MOVE"; else echo "COPY"; fi)"

# 遍历 Downloads 文件夹
find "$DOWNLOADS_DIR" -maxdepth 1 -type f ! -name ".*" | while read -r file; do
    organize_file "$file"
done

echo "Done! See $LOG_FILE for details."
```

## 与 OpenClaw 集成

可以创建一个 cron job 定期调用：

```json
{
  "name": "Auto File Organizer",
  "schedule": { "kind": "cron", "expr": "0 3 * * *" },
  "payload": { "kind": "systemEvent", "text": "Run auto file organizer" }
}
```

## 注意事项

1. 首次使用建议用 `--preview` 模式预览
2. 移动模式会删除原文件，复制模式保留副本
3. 建议配合 Time Machine 使用
4. 可修改脚本自定义分类规则
