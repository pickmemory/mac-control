#!/bin/bash
# Mac 坐标校准脚本
# 用于测试 Retina 显示屏的坐标转换

echo "🎯 Mac 坐标校准测试"
echo "=================="
echo ""

# 获取屏幕信息
echo "📊 屏幕信息:"
system_profiler SPDisplaysDataType | grep -A5 "Resolution" | head -10
echo ""

# 获取当前鼠标位置
echo "🖱️  当前鼠标位置:"
/opt/homebrew/bin/cliclick p
echo ""

# 测试坐标
echo "📍 测试步骤:"
echo "1. 记录当前鼠标位置"
read -p "按回车继续..."

# 移动到屏幕左上角
echo "2. 移动到屏幕左上角 (100, 100)"
/opt/homebrew/bin/cliclick c:100,100
sleep 1
echo "   实际位置："
/opt/homebrew/bin/cliclick p

read -p "按回车继续到下一步..."

# 移动到屏幕中央
echo "3. 移动到屏幕中央 (1280, 800)"
/opt/homebrew/bin/cliclick c:1280,800
sleep 1
echo "   实际位置："
/opt/homebrew/bin/cliclick p

echo ""
echo "✅ 校准完成"
echo ""
echo "📝 说明:"
echo "- 如果鼠标移动到了预期位置，说明坐标系统正确"
echo "- 如果位置不对，可能需要调整坐标转换比例"
