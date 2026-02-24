# Mac Vision Auto

全视觉 Mac 自动化工具 - 结合截图分析、颜色检测、键盘导航、AppleScript 的可靠自动化方案。

## 为什么需要这个工具？

现有的 `mac-control` skill 在浏览器自动化方面有限制：
- ❌ cliclick 点击在浏览器页面内不工作（浏览器安全保护）
- ❌ 纯鼠标点击容易被反自动化机制阻止
- ❌ 缺少视觉反馈和验证

## 解决方案

**多策略混合架构**：

```
1. 优先使用键盘导航（最可靠，绕过鼠标保护）
2. 回退到 AppleScript 应用级控制
3. 最后使用 cliclick 系统级点击
4. 所有操作都有截图验证
```

## 安装

```bash
# 克隆或复制到本地
cd ~/.openclaw/workspace/skills/
# mac-vision-auto 目录已存在

# 添加执行权限
chmod +x mac-vision-auto/mac-vision-auto.sh
```

## 权限要求

首次使用前，需要授予权限：

### 1. 辅助功能权限
```
系统设置 → 隐私与安全性 → 辅助功能 → 添加 Terminal
```

### 2. 屏幕录制权限
```
系统设置 → 隐私与安全性 → 屏幕录制 → 添加 Terminal
```

### 3. 自动化权限
```
系统设置 → 隐私与安全性 → 自动化 → 添加 Terminal
```

## 使用示例

### 点击操作

```bash
# 基础点击（自动选择最佳策略）
./mac-vision-auto.sh click 720 450 auto

# 强制使用 cliclick
./mac-vision-auto.sh click 720 450 cliclick

# 强制使用键盘导航
./mac-vision-auto.sh click 720 450 keyboard

# 点击指定颜色区域
./mac-vision-auto.sh click-color "#667eea"
```

### 键盘导航

```bash
# Tab 3 次，然后按空格
./mac-vision-auto.sh keyboard "tab:3,space"

# 复杂序列
./mac-vision-auto.sh keyboard "tab:2,return,tab,space"

# 输入文本
./mac-vision-auto.sh type "Hello World"
```

### 应用控制

```bash
# 打开应用
./mac-vision-auto.sh app open "Google Chrome"

# 激活窗口
./mac-vision-auto.sh app activate "Google Chrome"

# 关闭窗口
./mac-vision-auto.sh app close "Google Chrome"

# 获取窗口信息
./mac-vision-auto.sh app front "Google Chrome"
```

### 视觉搜索

```bash
# 查找颜色区域
./mac-vision-auto.sh find-color "#667eea"

# 截图
./mac-vision-auto.sh screenshot "my-screenshot"
```

### 校准

```bash
# 坐标校准
./mac-vision-auto.sh calibrate
```

## 坐标系统

| 工具 | 坐标类型 | 尺寸 | 转换 |
|------|---------|------|------|
| 截图 | 物理像素 | 2880x1800 | ÷2 = cliclick |
| cliclick | 逻辑坐标 | 1440x900 | 基准 |
| AppleScript | 逻辑坐标 | 1440x900 | 1:1 |

**使用截图坐标时，工具会自动转换！**

## 故障排除

### 点击不生效
1. 检查辅助功能权限是否授予
2. 尝试使用键盘导航：`click x y keyboard`
3. 使用 AppleScript：`click x y applescript`

### 坐标不准确
1. 运行校准：`./mac-vision-auto.sh calibrate`
2. 验证截图尺寸：`sips -g pixelWidth -g pixelHeight /tmp/vision-auto/screenshot.png`

### 浏览器无响应
1. 使用键盘导航（最可靠）
2. 确保浏览器窗口在前台
3. 尝试激活应用：`app activate "Google Chrome"`

## 与 mac-control 的对比

| 功能 | mac-control | mac-vision-auto |
|------|-------------|-----------------|
| 鼠标点击 | ✅ | ✅ (多策略) |
| 键盘导航 | ⚠️ 手动 | ✅ 内置 |
| 颜色检测 | ⚠️ 手动 | ✅ 内置 |
| 应用控制 | ⚠️ 手动 | ✅ 内置 |
| 自动验证 | ❌ | ✅ 截图对比 |
| 浏览器兼容 | ❌ 差 | ✅ 好 |
| 故障恢复 | ❌ | ✅ 自动重试 |

## 最佳实践

1. **优先键盘导航** - 对于浏览器和受保护的应用
2. **截图验证** - 关键操作前后截图对比
3. **错误处理** - 使用 auto 策略自动回退
4. **权限检查** - 首次使用前确保权限正确

## 贡献

欢迎提交 Issue 和 PR！

## 许可证

MIT
