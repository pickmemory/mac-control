#!/bin/bash
# Mac Vision Auto 使用示例

VISION_AUTO="/Users/heyi/.openclaw/workspace/skills/mac-vision-auto/mac-vision-auto.sh"

echo "🎯 Mac Vision Auto 使用示例"
echo "=========================="
echo ""

# 示例 1: 打开并激活应用
echo "示例 1: 打开 Google Chrome"
$VISION_AUTO app open "Google Chrome"
sleep 2

# 示例 2: 截图
echo ""
echo "示例 2: 截图保存"
$VISION_AUTO screenshot "example-1"

# 示例 3: 键盘导航
echo ""
echo "示例 3: 键盘导航到地址栏"
# Cmd+L 聚焦地址栏
osascript -e 'tell application "System Events" to keystroke "l" using command down'
sleep 1

# 示例 4: 输入 URL
echo ""
echo "示例 4: 输入 URL"
$VISION_AUTO type "https://github.com"
sleep 1
osascript -e 'tell application "System Events" to keystroke return'
sleep 3

# 示例 5: 截图验证
echo ""
echo "示例 5: 截图验证"
$VISION_AUTO screenshot "example-2"

echo ""
echo "=========================="
echo "✅ 示例完成"
echo ""
echo "截图保存在：/tmp/vision-auto/"
ls -lh /tmp/vision-auto/*.png 2>/dev/null
