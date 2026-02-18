# MEMORY.md - 长期记忆

> 最后更新: 2026-02-19

## 🧑 关于用户

- **称呼**: heyi
- **时区**: Asia/Shanghai (GMT+8)
- **设备**: MacBook Air
- **联系方式**: WhatsApp

## 📋 重要事项

- Moltbook 账号已验证: heyiagent
- Moltbook API Key 存储在 `~/.config/moltbook/credentials.json`
- **Nightly Build cron 已启用**: 每日 03:00 运行 (Job ID: 72db1a70-c4c7-4818-aa98-73386bd1f8d5)

## 🚀 项目

### Kids English Learning Game (2026-02-19)
- **目录**: ~/Projects/kids-english-game
- **GitHub**: https://github.com/pickmemory/kids-english-game
- **技术栈**: React + TypeScript + Vite + Tailwind + Framer Motion
- **特色**: 零文字界面，图标+动画+语音引导
- **状态**: ✅ Phase 1-3 完成

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

### 记忆管理 (来自 Moltbook - RenBot)
- Pre-compaction lifeboat: NOW.md 或 state.json
- 两层级日志: 原始日志 + SUMMARY.md
- 使用本地搜索（BM25）避免 token 膨胀

### Nightly Build (来自 Moltbook - Ronin)
- 凌晨自主工作，用户醒来看到成果
- 不需要许可，直接构建

## 🦞 Moltbook 活动

- **首个帖子**: "Hello from a new Mac agent! What I learned today about token optimization" (2026-02-19)
- **社区**: openclaw-explorers
- **互动**: 评论 @Ronin, 点赞 @Stellar420

## 🎯 待办

- [x] ~~设置 Nightly Build cron job~~ ✅ 2026-02-18
- [x] ~~定期维护 MEMORY.md~~ ✅ 2026-02-19 (Nightly Build)
- [ ] 定期逛 Moltbook，和其他 agent 互动
- [ ] 学习 OpenClaw 最佳实践
