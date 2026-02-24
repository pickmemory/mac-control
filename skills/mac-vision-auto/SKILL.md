---
name: mac-vision-auto
description: 全视觉 Mac 自动化工具 - 结合截图分析、颜色检测、键盘导航、AppleScript 的可靠自动化工具
---

# Mac Vision Auto - 全视觉自动化工具

**核心理念：** 多策略混合，确保可靠性

## 架构设计

```
┌─────────────────────────────────────────────────────┐
│              Mac Vision Auto                        │
├─────────────────────────────────────────────────────┤
│  1. 截图分析层 (Screenshot Analysis)                │
│     - 全屏/窗口截图                                 │
│     - 颜色检测与定位                                │
│     - 元素识别                                      │
├─────────────────────────────────────────────────────┤
│  2. 控制执行层 (Control Execution)                  │
│     - 策略 A: AppleScript (应用级控制)              │
│     - 策略 B: 键盘导航 (最可靠)                     │
│     - 策略 C: cliclick (系统级点击)                 │
│     - 策略 D: JavaScript 注入 (需开发者模式)        │
├─────────────────────────────────────────────────────┤
│  3. 验证层 (Verification)                           │
│     - 截图对比                                      │
│     - 状态检测                                      │
│     - 自动重试                                      │
└─────────────────────────────────────────────────────┘
```

## 坐标系统

| 工具 | 坐标类型 | 说明 |
|------|---------|------|
| 截图 | 物理像素 | 2880x1800 (Retina 2x) |
| cliclick | 逻辑坐标 | 1440x900 (÷2) |
| AppleScript | 逻辑坐标 | 1440x900 |

## 使用示例

### 1. 基础点击

```bash
# 自动检测并点击
./mac-vision-auto.sh click "测试按钮"

# 带颜色检测的点击
./mac-vision-auto.sh click-color "#667eea"
```

### 2. 键盘导航

```bash
# Tab 导航 + 空格激活
./mac-vision-auto.sh keyboard "tab:3,space"

# 输入文本
./mac-vision-auto.sh type "Hello World"
```

### 3. 应用控制

```bash
# 打开应用
./mac-vision-auto.sh app open "Google Chrome"

# 激活窗口
./mac-vision-auto.sh app activate "Google Chrome"

# 关闭窗口
./mac-vision-auto.sh app close "Google Chrome"
```

### 4. 视觉搜索

```bash
# 查找颜色区域
./mac-vision-auto.sh find-color "#667eea"

# 查找文本区域
./mac-vision-auto.sh find-text "登录"
```

## 故障排除

### 点击不生效
1. 检查辅助功能权限
2. 尝试键盘导航替代
3. 使用 AppleScript 应用级控制

### 坐标不准确
1. 运行校准：`./mac-vision-auto.sh calibrate`
2. 验证截图尺寸
3. 检查 Retina 缩放

### 浏览器无响应
1. 使用键盘导航（最可靠）
2. 开启 Chrome 开发者模式
3. 使用 AppleScript + JavaScript

## 权限要求

- **辅助功能**: 系统设置 → 隐私与安全性 → 辅助功能 → Terminal
- **屏幕录制**: 系统设置 → 隐私与安全性 → 屏幕录制 → Terminal
- **自动化**: 系统设置 → 隐私与安全性 → 自动化 → Terminal
