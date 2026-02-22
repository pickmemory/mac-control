---
name: code-reviewer
description: 代码审查工具 - 自动审查 GitHub PR，支持代码质量检查、安全扫描、性能建议，自动生成审查报告。
---

# Code Reviewer

自动化代码审查工具，集成 GitHub PR 审查。

## 功能

- 🔍 代码质量分析
- 🛡️ 安全漏洞扫描
- ⚡ 性能优化建议
- 📝 风格规范检查
- 🔄 自动审查 PR
- 📊 审查历史统计
- 🏷️ 问题分类
- 📧 审查报告

## 使用方法

### 审查 PR

```bash
# 审查 GitHub PR
code-reviewer pr --owner facebook --repo react --pr 35863

# 审查本地代码
code-reviewer diff HEAD~1

# 审查文件
code-reviewer file src/App.tsx
```

### 配置规则

```bash
# 初始化配置
code-reviewer init

# 添加规则
code-reviewer rule add --severity error --pattern "console\.log"

# 列出规则
code-reviewer rule list
```

### GitHub 集成

```bash
# 设置 GitHub token
code-reviewer config --token $GITHUB_TOKEN

# 自动审查新 PR
code-reviewer webhook

# 审查所有待处理 PR
code-reviewer review-all
```

## 审查规则

### 代码质量
- 函数过长 (> 50 行)
- 代码重复
- 命名不规范
- 注释缺失

### 安全问题
- SQL 注入风险
- XSS 漏洞
- 敏感信息泄露
- 弱加密

### 性能问题
- N+1 查询
- 不必要的重渲染
- 大文件加载
- 内存泄漏

### 代码风格
- ESLint 规则
- Prettier 格式
- TypeScript 类型

## 配置文件

创建 `~/.code-reviewer/config.json`:

```json
{
  "rules": {
    "max_function_length": 50,
    "max_file_length": 500,
    "require_types": true,
    "security_scan": true,
    "performance_check": true
  },
  "severity": {
    "error": ["sql-injection", "xss", "secrets"],
    "warning": ["long-function", "naming"],
    "info": ["style", "format"]
  },
  "github": {
    "auto_review": true,
    "approve_style": true,
    "comment_style": "collapsible"
  },
  "notifications": {
    "slack": "https://hooks.slack.com/...",
    "email": "team@example.com"
  }
}
```

## 输出示例

```
$ code-reviewer pr --owner facebook --repo react --pr 35863

🔍 审查 PR #35863: fix: change private field from string to boolean

📊 审查结果
═══════════════════════════════════════════

✅ 通过: 12
⚠️  警告: 3
❌ 问题: 0

📝 详细审查:

[✅] 代码质量
   • 函数长度: ✅ 平均 12 行 (最大 28)
   • 代码重复: ✅ 未发现
   • 命名规范: ✅ 符合

[⚠️] 安全性
   • 敏感信息: ⚠️ 未检测到
   • SQL 注入: ✅ 安全
   • XSS: ✅ 安全

[ℹ️] 性能
   • N+1 查询: ✅ 无
   • 优化建议: 1 条
      → 考虑使用 const 替代 let (line 3)

[ℹ️] 代码风格
   • ESLint: ✅ 通过
   • TypeScript: ✅ 通过

📈 建议:
   • 可以在 commit message 中添加 issue 引用

✅ 审查完成! (耗时 2.3s)
```

## 与 OpenClaw 集成

```json
{
  "name": "Auto Review PR",
  "schedule": { "kind": "cron", "expr": "*/15 * * * *" },
  "payload": {
    "kind": "systemEvent",
    "text": "Run code review: code-reviewer review-all --owner myorg --repo myrepo"
  }
}
```

## 支持语言

- JavaScript/TypeScript
- Python
- Java
- Go
- Rust
- C/C++
- Ruby
- PHP

## 常用命令

```bash
# 快速审查
code-reviewer quick src/

# 详细报告
code-reviewer pr --pr 123 --report md > review.md

# 查看历史
code-reviewer history

# 导出问题
code-reviewer export --format json
```

## GitHub Actions 集成

创建 `.github/workflows/review.yml`:

```yaml
name: Auto Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Code Reviewer
        run: |
          code-reviewer pr --pr ${{ github.event.pull_request.number }} \
            --owner ${{ github.repository_owner }} \
            --repo ${{ github.event.repository.name }} \
            --token ${{ secrets.GITHUB_TOKEN }}
```

## 注意事项

1. 需要 GitHub Token (repo 权限)
2. 大项目注意 API 限制
3. 首次使用建议配置规则
4. 可自定义规则权重
5. 支持企业内部规则集
