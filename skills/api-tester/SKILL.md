---
name: api-tester
description: API 测试工具 - 简单易用的 REST API 测试工具，支持 GET/POST/PUT/DELETE 请求，支持环境变量、断言测试、响应格式化。
---

# API Tester

简单易用的命令行 API 测试工具。

## 功能

- 🌐 支持 GET/POST/PUT/PATCH/DELETE/HEAD/OPTIONS
- 📝 JSON/FormData/ multipart 数据支持
- 🔐 Bearer Token / Basic Auth 支持
- ✅ 断言测试（状态码、响应体、响应时间）
- 📋 响应格式化高亮
- 📁 请求历史记录
- 🌍 多环境支持（dev/staging/prod）
- 🔄 Collection 批量测试

## 使用方法

### 基础请求

```bash
# GET 请求
api-test get "https://api.example.com/users"

# POST 请求
api-test post "https://api.example.com/users" -d '{"name":"test"}'

# 带 Header
api-test get "https://api.example.com/users" -H "Authorization: Bearer token"
```

### 完整选项

```bash
api-test [METHOD] [URL] [OPTIONS]

Options:
  -d, --data <json>       请求体 (JSON)
  -H, --header <header>   自定义 Header (可多次使用)
  -u, --user <user:pass>  Basic Auth
  -t, --token <token>      Bearer Token
  -f, --file <file>       上传文件
  -o, --output <file>     保存响应到文件
  -v, --verbose           详细输出
  --timeout <ms>          超时时间 (默认 30000)
```

### 断言测试

```bash
# 断言状态码
api-test get "https://api.example.com/users" -a "status:200"

# 断言响应时间
api-test get "https://api.example.com/users" -a "time:<1000"

# 断言响应体
api-test get "https://api.example.com/users/1" -a "body:.name:test"
```

### 环境变量

```bash
# 设置环境
api-test env set dev "https://dev.api.com"
api-test env set prod "https://api.com"

# 使用环境
api-test get "{{base_url}}/users" --env dev
```

### Collection 运行

```bash
# 运行 collection
api-test run my_collection.json

# 生成 collection
api-test init my_api
```

## 请求历史

```bash
# 查看历史
api-test history

# 重新执行历史请求
api-test replay <id>

# 清空历史
api-test history clear
```

## 响应示例

```bash
$ api-test get https://jsonplaceholder.typicode.com/users/1

✅ 200 OK (245ms)

{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  ...
}
```

## 配置文件

创建 `~/.api-test/config.json`:

```json
{
  "environments": {
    "dev": { "base_url": "https://dev.api.com", "token": "dev_token" },
    "prod": { "base_url": "https://api.com", "token": "prod_token" }
  },
  "defaults": {
    "timeout": 30000,
    "headers": {
      "User-Agent": "APITester/1.0"
    }
  }
}
```

## 与 OpenClaw 集成

```json
{
  "name": "API Health Check",
  "schedule": { "kind": "every", "everyMs": 300000 },
  "payload": {
    "kind": "systemEvent",
    "text": "Run API health check: api-test get https://api.example.com/health"
  }
}
```

## 安装

```bash
# 复制到 PATH
cp -r ~/.openclaw/workspace/skills/api-tester /usr/local/bin/
```

## 注意事项

1. 默认超时 30 秒
2. 响应自动格式化 JSON/XML
3. 大响应自动分页
4. 敏感信息不保存到历史
