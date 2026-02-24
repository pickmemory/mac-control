#!/bin/bash
# 视觉控制坐标转换工具
# 自动处理 Retina 显示屏的坐标转换

set -e

# 配置
SCREENSHOT_SCALE=2  # Retina 2x 缩放

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo -e "${BLUE}🎯 视觉控制坐标转换工具${NC}"
    echo ""
    echo "用法:"
    echo "  $0 convert <screenshot_x> <screenshot_y>   # 转换截图坐标为 cliclick 坐标"
    echo "  $0 click <screenshot_x> <screenshot_y>     # 直接点击截图坐标位置"
    echo "  $0 info                                    # 显示当前坐标系统信息"
    echo "  $0 calibrate                               # 运行坐标校准"
    echo ""
    echo "示例:"
    echo "  $0 convert 1000 600   # 输出：500,300"
    echo "  $0 click 1000 600     # 点击截图坐标 (1000,600) 对应的位置"
    echo ""
}

get_screen_info() {
    echo -e "${BLUE}📊 屏幕信息:${NC}"
    echo ""
    
    # 获取逻辑分辨率
    LOGICAL_RES=$(osascript -e 'tell application "System Events" to tell process "Finder" to get bounds of front window' 2>/dev/null || echo "0, 0, 1440, 900")
    echo "  逻辑分辨率 (points): 需要手动测量"
    
    # 获取截图分辨率
    /usr/sbin/screencapture -x /tmp/_calib_screen.png
    SCREENSHOT_RES=$(sips -g pixelWidth -g pixelHeight /tmp/_calib_screen.png 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | paste -sd x -)
    rm -f /tmp/_calib_screen.png
    echo "  截图分辨率 (pixels): $SCREENSHOT_RES"
    
    # 获取当前鼠标位置
    MOUSE_POS=$(/opt/homebrew/bin/cliclick p)
    echo "  当前鼠标位置：$MOUSE_POS"
    
    echo ""
    echo -e "${YELLOW}  注意：cliclick 使用逻辑坐标 (points)，截图使用物理像素 (pixels)${NC}"
    echo -e "${YELLOW}  转换公式：cliclick = 截图坐标 / $SCREENSHOT_SCALE${NC}"
}

convert_coords() {
    local screenshot_x=$1
    local screenshot_y=$2
    
    local cliclick_x=$((screenshot_x / SCREENSHOT_SCALE))
    local cliclick_y=$((screenshot_y / SCREENSHOT_SCALE))
    
    echo -e "${GREEN}✅ 坐标转换结果:${NC}"
    echo ""
    echo "  截图坐标：($screenshot_x, $screenshot_y)"
    echo "  cliclick 坐标：($cliclick_x, $cliclick_y)"
    echo ""
    echo "  使用命令:"
    echo "  /opt/homebrew/bin/cliclick c:$cliclick_x,$cliclick_y"
}

click_at() {
    local screenshot_x=$1
    local screenshot_y=$2
    local cliclick_x=$((screenshot_x / SCREENSHOT_SCALE))
    local cliclick_y=$((screenshot_y / SCREENSHOT_SCALE))
    
    echo -e "${BLUE}🎯 点击目标:${NC}"
    echo "  截图坐标：($screenshot_x, $screenshot_y)"
    echo "  cliclick 坐标：($cliclick_x, $cliclick_y)"
    echo ""
    
    # 先移动鼠标到目标位置（不点击）
    echo "  移动鼠标..."
    /opt/homebrew/bin/cliclick m:$cliclick_x,$cliclick_y
    sleep 0.5
    
    # 显示确认提示
    echo -e "${YELLOW}  鼠标已移动到目标位置上方${NC}"
    echo -e "${YELLOW}  按回车确认点击，或 Ctrl+C 取消${NC}"
    read -p ""
    
    # 点击
    echo "  点击..."
    /opt/homebrew/bin/cliclick c:$cliclick_x,$cliclick_y
    
    echo -e "${GREEN}✅ 点击完成${NC}"
}

run_calibration() {
    echo -e "${BLUE}🔧 运行坐标校准...${NC}"
    echo ""
    
    # 检查校准脚本
    if [ -f "/Users/heyi/.openclaw/workspace/skills/mac-control/calibrate-coordinates.sh" ]; then
        bash "/Users/heyi/.openclaw/workspace/skills/mac-control/calibrate-coordinates.sh"
    else
        echo -e "${RED}❌ 校准脚本不存在${NC}"
        echo "  位置：/Users/heyi/.openclaw/workspace/skills/mac-control/calibrate-coordinates.sh"
    fi
}

# 主程序
case "${1:-info}" in
    convert)
        if [ $# -lt 3 ]; then
            usage
            exit 1
        fi
        convert_coords "$2" "$3"
        ;;
    click)
        if [ $# -lt 3 ]; then
            usage
            exit 1
        fi
        click_at "$2" "$3"
        ;;
    info)
        get_screen_info
        ;;
    calibrate)
        run_calibration
        ;;
    *)
        usage
        ;;
esac
