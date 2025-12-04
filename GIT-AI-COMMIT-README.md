# Git AI Commit

🤖 AI-powered Git commit message generator - 让 AI 帮你写 commit message！

## ✨ 特性

- 🎯 **智能分析** - 自动分析 git diff，生成准确的 commit message
- 🌍 **多语言支持** - 支持中英文 commit message
- 📝 **Conventional Commits** - 支持标准的 commit 格式（feat, fix, docs 等）
- 🔧 **灵活配置** - 支持多种 AI 模型和 API 配置
- 💬 **交互式** - 可以确认、编辑或重新生成 commit message
- ⚡ **智能优化** - 大 diff 自动摘要，避免超出 token 限制

## 🚀 快速开始

### 1. 安装

```bash
# 克隆或下载这些文件后，运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会：

- 将 `git-ai-commit` 复制到 `~/bin`
- 创建配置文件模板到 `~/.config/git-ai-commit.conf`

### 2. 配置

编辑 `~/.config/git-ai-commit.conf`，添加你的 AI 模型配置。

#### 方式 1：使用 Claude CLI（推荐）

```bash
USE_CLAUDE_CLI=true
ANTHROPIC_AUTH_TOKEN="your-api-key-here"
ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
ANTHROPIC_MODEL="GLM-4-Plus"
```

#### 方式 2：直接调用 API

```bash
# OpenAI
AI_API_URL="https://api.openai.com/v1/chat/completions"
AI_API_KEY="sk-your-key-here"
AI_MODEL="gpt-4"

# 或者其他兼容 OpenAI 格式的服务
AI_API_URL="https://your-custom-endpoint/v1/chat/completions"
AI_API_KEY="your-api-key"
AI_MODEL="your-model"
```

#### 其他配置选项

```bash
# 语言设置
LANGUAGE="zh"  # zh=中文, en=英文

# Commit 格式
COMMIT_FORMAT="conventional"  # conventional 或 simple

# Diff 大小限制
MAX_DIFF_LINES=500
```

### 3. 使用

```bash
# 在任何 git 仓库中
git add .
git-ai-commit
```

就这么简单！AI 会分析你的改动并生成 commit message。

## 📖 使用示例

### 基本流程

```bash
$ git add src/App.jsx
$ git-ai-commit

ℹ️  Files changed: 1, Insertions: +23, Deletions: -5

ℹ️  Analyzing changes...
ℹ️  Using Claude CLI...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(ui): 添加用户头像显示功能

在用户资料卡片中添加头像显示组件，支持默认头像和自定义上传
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Options:
  [y] Use this message
  [e] Edit this message
  [r] Regenerate message
  [n] Cancel

Your choice: y
✅ Committed successfully!
```

### 命令选项

```bash
git-ai-commit -h         # 显示帮助
git-ai-commit -v         # 显示版本
git-ai-commit -c         # 显示当前配置
```

## 🎨 Commit 格式说明

使用 `COMMIT_FORMAT="conventional"` 时，生成的 commit 会遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档修改
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关

示例：

```
feat(auth): 添加用户登录功能
fix(ui): 修复按钮样式错误
docs: 更新 README 文档
```

## 🔧 高级用法

### Shell 函数快捷方式

你也可以在 `~/.bashrc` 或 `~/.zshrc` 中添加快捷函数：

```bash
# 快速 commit（类似你原来的 cmt 函数）
function cmt() {
    git add .
    git-ai-commit
}

# 或者针对特定改动
function acmt() {
    git add "$@"
    git-ai-commit
}
```

然后：

```bash
cmt                    # add all 并 commit
acmt src/*.js          # 只 commit 特定文件
```

### 环境变量覆盖

你也可以临时覆盖配置：

```bash
LANGUAGE=en git-ai-commit           # 使用英文
COMMIT_FORMAT=simple git-ai-commit  # 使用简单格式
```

## 🛠️ 故障排查

### 问题：AI 模型没有响应

确保：

1. API key 配置正确
2. API endpoint 可访问
3. 如果使用 Claude CLI，确保已安装：`claude --version`

### 问题：~/bin 不在 PATH 中

添加到你的 shell 配置文件（`~/.bashrc` 或 `~/.zshrc`）：

```bash
export PATH="$HOME/bin:$PATH"
```

然后重新加载：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

### 问题：Diff 太大

工具会自动检测 diff 大小，如果超过限制会只发送文件列表和统计信息。你可以调整 `MAX_DIFF_LINES` 配置。

## 📝 文件说明

- `git-ai-commit.sh` - 主脚本
- `git-ai-commit.conf.example` - 配置文件模板
- `install.sh` - 安装脚本
- `README.md` - 本文档

## 🤝 贡献

欢迎提交 issue 和 pull request！

## 📄 License

MIT License

---

**Enjoy! 让 AI 成为你的 commit 小助手！** 🚀
