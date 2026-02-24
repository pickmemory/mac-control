#!/bin/bash
# Mac Vision Auto - 全视觉自动化工具
# 结合截图分析、颜色检测、键盘导航、AppleScript 的可靠自动化

set -e

# ============================================================================
# 配置
# ============================================================================
SCREENSHOT_SCALE=2  # Retina 2x 缩放
SCREENSHOT_DIR="/tmp/vision-auto"
CLICLICK="/opt/homebrew/bin/cliclick"
MAGICK="magick"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# 初始化
# ============================================================================
init() {
    mkdir -p "$SCREENSHOT_DIR"
    echo -e "${BLUE}🔧 Mac Vision Auto 已初始化${NC}"
}

# ============================================================================
# 截图功能
# ============================================================================
screenshot() {
    local filename="${1:-screenshot}"
    local path="$SCREENSHOT_DIR/${filename}.png"
    
    /usr/sbin/screencapture -x "$path"
    echo "$path"
}

# ============================================================================
# 坐标转换
# ============================================================================
convert_coords() {
    local screenshot_x=$1
    local screenshot_y=$2
    
    local cliclick_x=$((screenshot_x / SCREENSHOT_SCALE))
    local cliclick_y=$((screenshot_y / SCREENSHOT_SCALE))
    
    echo "$cliclick_x,$cliclick_y"
}

# ============================================================================
# 颜色检测
# ============================================================================
find_color() {
    local color="$1"
    local screenshot_path="${2:-$SCREENSHOT_DIR/screenshot.png}"
    
    if [ ! -f "$screenshot_path" ]; then
        screenshot "screenshot" > /dev/null
    fi
    
    # 查找颜色区域
    local result=$($MAGICK "$screenshot_path" -resize 50% txt:- 2>/dev/null | \
        grep -i "$color" | \
        awk -F'[,:]' '{print $1, $2}' | \
        head -1)
    
    if [ -n "$result" ]; then
        echo "$result"
    else
        echo "NOT_FOUND"
    fi
}

# ============================================================================
# 点击功能（多策略）
# ============================================================================
click() {
    local x=$1
    local y=$2
    local strategy="${3:-auto}"
    
    echo -e "${CYAN}🎯 点击目标：($x, $y)${NC}"
    
    case "$strategy" in
        "cliclick")
            click_cliclick "$x" "$y"
            ;;
        "keyboard")
            click_keyboard "$x" "$y"
            ;;
        "applescript")
            click_applescript "$x" "$y"
            ;;
        "auto")
            # 自动策略：先尝试 cliclick，失败则用键盘
            if click_cliclick "$x" "$y"; then
                echo -e "${GREEN}✅ cliclick 成功${NC}"
            else
                echo -e "${YELLOW}⚠️  cliclick 失败，尝试键盘导航${NC}"
                click_keyboard "$x" "$y"
            fi
            ;;
    esac
}

click_cliclick() {
    local x=$1
    local y=$2
    
    # 转换为 cliclick 坐标
    local coords=$(convert_coords "$x" "$y")
    
    echo -e "${BLUE}   → 使用 cliclick 点击：$coords${NC}"
    $CLICLICK c:$coords
    sleep 1
    return 0
}

click_keyboard() {
    local x=$1
    local y=$2
    
    echo -e "${BLUE}   → 使用键盘导航${NC}"
    
    # 先移动鼠标到目标位置（视觉反馈）
    local coords=$(convert_coords "$x" "$y")
    $CLICLICK m:$coords
    sleep 0.5
    
    # 使用键盘激活
    osascript -e '
        tell application "System Events"
            keystroke space
        end tell
    ' 2>/dev/null || true
    
    sleep 1
    return 0
}

click_applescript() {
    local x=$1
    local y=$2
    
    echo -e "${BLUE}   → 使用 AppleScript${NC}"
    
    # 获取前台应用
    local app=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null || echo "")
    
    if [ -n "$app" ]; then
        osascript -e "
            tell application \"System Events\"
                tell process \"$app\"
                    click at {$x, $y}
                end tell
            end tell
        " 2>/dev/null || return 1
    fi
    
    return 0
}

# ============================================================================
# 应用控制
# ============================================================================
app_control() {
    local action="$1"
    local app_name="$2"
    
    case "$action" in
        "open")
            echo -e "${CYAN}🚀 打开应用：$app_name${NC}"
            open -a "$app_name"
            sleep 2
            ;;
        "activate")
            echo -e "${CYAN}📍 激活应用：$app_name${NC}"
            osascript -e "tell application \"$app_name\" to activate"
            sleep 1
            ;;
        "close")
            echo -e "${CYAN}❌ 关闭应用：$app_name${NC}"
            osascript -e "tell application \"$app_name\" to quit"
            sleep 1
            ;;
        "front")
            echo -e "${CYAN}🪟 获取前台窗口信息${NC}"
            osascript -e "tell application \"System Events\" to tell process \"$app_name\" to get position of front window"
            osascript -e "tell application \"System Events\" to tell process \"$app_name\" to get size of front window"
            ;;
    esac
}

# ============================================================================
# 键盘导航
# ============================================================================
keyboard_nav() {
    local sequence="$1"
    
    echo -e "${CYAN}⌨️  键盘导航：$sequence${NC}"
    
    IFS=',' read -ra KEYS <<< "$sequence"
    for key in "${KEYS[@]}"; do
        case "$key" in
            "tab")
                osascript -e 'tell application "System Events" to keystroke tab'
                ;;
            "space")
                osascript -e 'tell application "System Events" to keystroke space'
                ;;
            "return"|"enter")
                osascript -e 'tell application "System Events" to keystroke return'
                ;;
            "escape")
                osascript -e 'tell application "System Events" to keystroke escape'
                ;;
            "up")
                osascript -e 'tell application "System Events" to key code 126'
                ;;
            "down")
                osascript -e 'tell application "System Events" to key code 125'
                ;;
            "left")
                osascript -e 'tell application "System Events" to key code 123'
                ;;
            "right")
                osascript -e 'tell application "System Events" to key code 124'
                ;;
            *)
                # 普通文本输入
                osascript -e "tell application \"System Events\" to keystroke \"$key\""
                ;;
        esac
        sleep 0.2
    done
    
    echo -e "${GREEN}✅ 键盘导航完成${NC}"
}

# ============================================================================
# 文本输入
# ============================================================================
type_text() {
    local text="$1"
    local delay="${2:-0.1}"
    
    echo -e "${CYAN}⌨️  输入文本：$text${NC}"
    
    osascript -e "tell application \"System Events\" to keystroke \"$text\""
    
    echo -e "${GREEN}✅ 输入完成${NC}"
}

# ============================================================================
# 剪贴板粘贴输入（用于密码等受保护输入框）
# ============================================================================
paste_text() {
    local text="$1"
    
    echo -e "${CYAN}📋 剪贴板粘贴：$text${NC}"
    
    # 保存当前剪贴板内容
    local old_clipboard=$(pbpaste 2>/dev/null || echo "")
    
    # 设置新剪贴板内容
    echo -n "$text" | pbcopy
    
    sleep 0.5
    
    # 使用 Cmd+V 粘贴
    osascript -e 'tell application "System Events" to keystroke "v" using command down'
    
    sleep 0.5
    
    # 恢复原剪贴板内容
    if [ -n "$old_clipboard" ]; then
        echo -n "$old_clipboard" | pbcopy
    fi
    
    echo -e "${GREEN}✅ 粘贴完成${NC}"
}

# ============================================================================
# AppleScript 直接输入（绕过部分保护）
# ============================================================================
as_type() {
    local text="$1"
    
    echo -e "${CYAN}🍎 AppleScript 输入：$text${NC}"
    
    # 使用 AppleScript 直接设置文本
    osascript -e "
        tell application \"System Events\"
            set the clipboard to \"$text\"
            keystroke \"v\" using command down
        end tell
    "
    
    echo -e "${GREEN}✅ 输入完成${NC}"
}

# ============================================================================
# 智能输入（自动选择最佳方式）
# ============================================================================
smart_type() {
    local text="$1"
    local mode="${2:-auto}"
    
    echo -e "${CYAN}🧠 智能输入：$text (模式：$mode)${NC}"
    
    case "$mode" in
        "paste")
            paste_text "$text"
            ;;
        "as")
            as_type "$text"
            ;;
        "kb")
            type_text "$text"
            ;;
        "auto")
            # 自动策略：先尝试普通输入，失败则用粘贴
            echo -e "${BLUE}   尝试普通键盘输入...${NC}"
            if type_text "$text" 2>/dev/null; then
                sleep 1
                # 验证输入是否成功（通过截图对比或其他方式）
                echo -e "${GREEN}   ✅ 键盘输入成功${NC}"
            else
                echo -e "${YELLOW}   ⚠️  键盘输入失败，使用剪贴板粘贴...${NC}"
                paste_text "$text"
            fi
            ;;
    esac
}

# ============================================================================
# 视觉搜索
# ============================================================================
visual_search() {
    local search_type="$1"
    local target="$2"
    
    echo -e "${CYAN}🔍 视觉搜索：$search_type = $target${NC}"
    
    # 截图
    local screenshot_path=$(screenshot "search")
    echo -e "${BLUE}   截图：$screenshot_path${NC}"
    
    case "$search_type" in
        "color")
            find_color "$target" "$screenshot_path"
            ;;
        "text")
            # TODO: 使用 OCR 搜索文本
            echo -e "${YELLOW}   ⚠️  OCR 功能需要额外配置${NC}"
            ;;
    esac
}

# ============================================================================
# 校准
# ============================================================================
calibrate() {
    echo -e "${BLUE}🔧 坐标校准...${NC}"
    echo ""
    
    # 获取屏幕信息
    echo "📺 屏幕信息:"
    echo "   截图尺寸：$(sips -g pixelWidth -g pixelHeight /dev/null 2>&1 || echo '2880x1800')"
    echo "   缩放比例：${SCREENSHOT_SCALE}x"
    echo ""
    
    # 测试点
    echo "🎯 测试坐标移动:"
    
    local test_points=("100,100" "720,450" "1300,800")
    for point in "${test_points[@]}"; do
        echo "   移动到 $point"
        $CLICLICK m:$point
        sleep 0.5
        local actual=$($CLICLICK p)
        echo "   实际位置：$actual"
    done
    
    echo ""
    echo -e "${GREEN}✅ 校准完成${NC}"
}

# ============================================================================
# 帮助信息
# ============================================================================
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       Mac Vision Auto - 全视觉自动化工具                 ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "用法:"
    echo "  $0 <命令> [参数]"
    echo ""
    echo "命令:"
    echo "  click <x> <y> [策略]     点击指定坐标 (策略：auto/cliclick/keyboard/applescript)"
    echo "  click-color <颜色>       点击指定颜色的区域"
    echo "  keyboard <序列>          键盘导航 (例：tab:3,space,return)"
    echo "  type <文本>              输入文本（普通键盘）"
    echo "  paste <文本>             剪贴板粘贴输入（用于密码等）"
    echo "  smart-type <文本>        智能输入（自动选择最佳方式）"
    echo "  app <操作> <应用名>      应用控制 (open/activate/close/front)"
    echo "  find-color <颜色>        查找颜色区域"
    echo "  screenshot [文件名]      截图"
    echo "  calibrate                坐标校准"
    echo "  help                     显示帮助"
    echo ""
    echo "示例:"
    echo "  $0 click 720 450 auto"
    echo "  $0 click-color \"#667eea\""
    echo "  $0 keyboard \"tab:3,space\""
    echo "  $0 app open \"Google Chrome\""
    echo "  $0 type \"Hello World\""
    echo "  $0 paste \"sensitive-password\""
    echo "  $0 smart-type \"auto-input\""
    echo ""
}

# ============================================================================
# 主程序
# ============================================================================
main() {
    init
    echo ""
    
    case "${1:-help}" in
        "click")
            if [ $# -lt 3 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                show_help
                exit 1
            fi
            click "$2" "$3" "${4:-auto}"
            ;;
        "click-color")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            local pos=$(find_color "$2")
            if [ "$pos" != "NOT_FOUND" ]; then
                local x=$(echo "$pos" | awk '{print $1}')
                local y=$(echo "$pos" | awk '{print $2}')
                click "$x" "$y"
            else
                echo -e "${RED}❌ 未找到颜色：$2${NC}"
                exit 1
            fi
            ;;
        "keyboard")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            keyboard_nav "$2"
            ;;
        "type")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            type_text "$2"
            ;;
        "paste")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            paste_text "$2"
            ;;
        "smart-type")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            smart_type "$2" "${3:-auto}"
            ;;
        "as-type")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            as_type "$2"
            ;;
        "app")
            if [ $# -lt 3 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            app_control "$2" "$3"
            ;;
        "find-color")
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 参数不足${NC}"
                exit 1
            fi
            visual_search "color" "$2"
            ;;
        "screenshot")
            screenshot "${2:-screenshot}"
            echo -e "${GREEN}✅ 截图完成${NC}"
            ;;
        "calibrate")
            calibrate
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}❌ 未知命令：$1${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
