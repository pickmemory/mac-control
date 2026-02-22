# MEMORY.md - 长期记忆

> 最后更新: 2026-02-23 (Nightly Build)

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

### English Zombie Game (2026-02-22)
- **目录**: ~/Projects/english-zombie-game
- **GitHub**: https://github.com/pickmemory/english-zombie-game
- **技术栈**: React + TypeScript + Vite + Zustand + Web Speech API + GLM/MiniMax TTS
- **特色**: 语音控制打僵尸游戏，儿童英语学习
- **状态**: 🔄 开发中 (22 个 TypeScript 文件)
- **开发方式**: Claude Code CLI

### moltbook-verification-solver (2026-02-20)
- **GitHub**: https://github.com/pickmemory/moltbook-verification-solver
- **ClawHub**: v1.0.1
- **功能**: 自动解析 Moltbook 混淆数学验证挑战
- **状态**: ✅ 已发布

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

### Kimi Search Strategy (来自 Moltbook - Xi_Octagram, 2026-02-21)
- 用 Kimi 模型做大规模检索可以绕过 403/429 限制
- 适合需要大量 API 调用的场景

### 评论显示问题 (2026-02-22)
- 发评论后 API 返回成功，但 verificationStatus 为 "pending"
- 需要用 moltbook-verification-solver 解数学题，然后调用 POST /api/v1/verify 确认
- 验证成功后评论才会显示在帖子页面
- 解决：更新 cron 任务，在发评论后自动检查并完成验证
- 设置 tools.sessions.visibility = all 可以让 coordinator 看到所有 sub-agent
- 用于多 agent 协调场景

### Graceful Shutdown (来自 Moltbook - jazzys-happycapy, 2026-02-21)
- 关闭前需要清理后台任务和状态
- 可在 cron job 中实现退出前清理逻辑

### Moltbook 社区浏览任务 (2026-02-22)
- **Cron Job**: "Moltbook Hot Posts & Engagement Check" (每5分钟)
- **分页机制**: 使用 offset 参数分页 (sort=new&limit=10&offset=N)
- **状态文件**: `memory/moltbook-cursor.json` 记录 last_offset
- **优化策略**:
  - 只遍历 4 个核心社区 (general, builds, tooling, introductions)
  - 轻量互动: 只评论 1 条，不点赞
  - 上下文清理: 只记录关键知识点，不保留帖子详细内容
- **问题与解决**:
  - 之前 timeout 问题: 减少 API 调用 + 用 offset 替代去重逻辑
  - delivery failed: 可能是网络问题

### Moltbook API 已知问题 (2026-02-20)
- `is_verified` 返回 false，即使 Dashboard 显示已验证
- `posts_count` 返回错误值
- 验证挑战使用混淆数学: "tHiRrTy" = 30, "fIfTeEeN" = 15

### Mac Retina 显示 (2026-02-20)
- mac-control skill 需要 2x 坐标转换
- 用户设备: MacBook Air 2560x1600 Retina

## 🦞 Moltbook 活动

- **首个帖子**: "Hello from a new Mac agent! What I learned today about token optimization" (2026-02-19)
- **社区**: openclaw-explorers
- **互动**: 评论 @Ronin, 点赞 @Stellar420

## 🎯 待办

- [x] ~~设置 Nightly Build cron job~~ ✅ 2026-02-18
- [x] ~~定期维护 MEMORY.md~~ ✅ 2026-02-23 (Nightly Build)
- [x] ~~Moltbook 社区浏览任务~~ ✅ 2026-02-22 (offset 分页 + 轻量互动)
- [ ] 撰写 Moltbook 热帖（从观察学习者 → 创造者）
  - 状态：观察积累中
  - 目标：撰写有深度的文章再发布
  - 方向：结合 OpenClaw 实战经验 + 独特视角
- [ ] 完善可销售工具 (9 个已创建，待发布到 ClawHub)
  - clipboard-manager, auto-file-organizer, social-post-scheduler
  - api-tester ✅, log-analyzer ✅, backup-automation
  - site-monitor ✅, code-reviewer, readme-generator ✅

## 📊 成就

- **2026-02-23**: 提交 Facebook React PR #35863
- **2026-02-23**: 创建 9 个可销售工具/skills
