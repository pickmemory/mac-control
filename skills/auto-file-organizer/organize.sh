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
