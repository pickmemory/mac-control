---
name: readme-generator
description: README 生成器 - 自动为 GitHub 项目生成专业的 README 文档，支持多种模板，自动检测项目类型。
---

# README Generator

自动生成专业的 GitHub 项目 README 文档。

## 功能

- 🤖 自动检测项目类型
- 📝 多种模板选择
- 📊 自动提取项目统计
- 🏷️ 标签自动生成
- 📦 依赖徽章
- 📈 CI/CD 状态
- 👥 贡献者头像
- 🌐 多语言支持

## 使用方法

### 快速生成

```bash
# 自动检测并生成
readme-gen

# 指定项目目录
readme-gen --path ./my-project

# 交互式生成
readme-gen init
```

### 模板选择

```bash
# 使用模板
readme-gen --template open-source    # 开源项目
readme-gen --template api             # API 项目
readme-gen --template cli             # CLI 工具
readme-gen --template library         # 库/包
readme-gen --template saas            # SaaS 产品
readme-gen --template learning        # 学习项目
```

### 自定义选项

```bash
# 包含所有部分
readme-gen --all

# 选择部分
readme-gen --sections "intro,install,usage,api,contrib"

# 添加目录
readme-gen --toc

# 中文 README
readme-gen --lang zh-CN
```

## 项目检测

自动检测以下内容：

- 📦 包管理器 (npm, pip, cargo, etc.)
- 🌍 框架 (React, Vue, Django, etc.)
- 🗂️ 项目结构
- 📋 许可证
- 👥 作者信息
- 🔧 构建工具

## 输出示例

```
$ readme-gen

🔍 检测项目信息...
   类型: Node.js CLI 工具
   框架: Commander.js
   包管理器: npm
   
📝 生成 README...
   模板: cli
   语言: English
   
✅ README.md 已生成!

📊 预览:
═══════════════════════════════════════════

# my-cli-tool

CLI tool for doing something awesome.

[![npm version][npm-version]][npm]
[![Build Status][ci]][ci-url]
[![License][license]][license-url]

## Features

- ⚡ Fast
- 🔥 Secure  
- 🎯 Easy to use

## Installation

```bash
npm install -g my-cli-tool
```

## Usage

```bash
my-cli-tool [command]

Commands:
  start    Start the application
  stop     Stop the application
  status   Show status
```

## API

...

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT © [Your Name](https://github.com/yourname)

[npm-version]: ...
═══════════════════════════════════════════
```

## 模板结构

### 开源模板
```
- 项目标题 & 描述
- 功能特点
- 快速开始
- 安装
- 使用
- API 参考
- 配置
- 贡献指南
- 赞助
- 许可证
- 联系方式
```

### API 模板
```
- 项目标题
- 功能列表
- 端点文档
- 认证
- 示例
- 错误码
- 限流
- SDK
```

### CLI 模板
```
- 项目标题
- 功能
- 安装
- 使用
- 命令列表
- 配置
- 环境变量
- 示例
```

## 配置文件

创建 `readme-gen.config.json`:

```json
{
  "template": "cli",
  "sections": [
    "title",
    "description", 
    "features",
    "installation",
    "usage",
    "commands",
    "api",
    "config",
    "contributing",
    "license"
  ],
  "badges": {
    "npm": true,
    "ci": true,
    "coverage": true,
    "license": true,
    "stars": true
  },
  "options": {
    "toc": true,
    "emoji": true,
    "darkMode": true
  }
}
```

## 与 OpenClaw 集成

```json
{
  "name": "Update README",
  "schedule": { "kind": "cron", "expr": "0 0 * * 0" },
  "payload": {
    "kind": "systemEvent",
    "text": "Update README: readme-gen --path ~/Projects/myproject"
  }
}
```

## 徽章支持

自动生成常用徽章：

- npm version
- Build status
- Test coverage
- License
- GitHub stars
- Dependencies
- Bundle size
- Language count

## 多语言

```bash
# 中文
readme-gen --lang zh-CN

# 日文
readme-gen --lang ja

# 英文 (默认)
readme-gen --lang en
```

## 注意事项

1. 需要项目目录有 package.json 或类似文件
2. GitHub token 可获取更多统计信息
3. 支持自定义模板
4. 生成后建议人工审核
5. 可集成到 CI/CD
