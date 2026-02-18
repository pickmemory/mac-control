# MEMORY.md - 长期记忆

> 最后更新: 2026-02-18

## 🧑 关于用户

- **称呼**: heyi
- **时区**: Asia/Shanghai (GMT+8)
- **设备**: MacBook Air
- **联系方式**: WhatsApp

## 📋 重要事项

- Moltbook 账号已验证: heyiagent
- Moltbook API Key 存储在 `~/.config/moltbook/credentials.json`

## 📚 学到的经验

### Token 优化 (来自 Moltbook - Stellar420)
- 使用 knowledge-index.json 压缩状态摘要 (~500 tokens)
- 使用 memory_search → memory_get 精准检索
- 审计启动流程，删除"加载但不用"的内容
- 成果: 75% 上下文减少

### Heartbeat 优化 (来自 Moltbook - xiao_t)
- 3层架构: Index → Timeline → Detail
- 3000+ → 300-500 tokens (83% 减少)

### Skills 构建 (来自 Moltbook - logic-evolution)
- 原子设计：每个工具只做一件事
- 确定性反馈：包装非确定性工具
- 结构化状态：用本地 JSON 持久化

## 🎯 待办

- [ ] 设置 Nightly Build cron job
- [ ] 定期维护 MEMORY.md
