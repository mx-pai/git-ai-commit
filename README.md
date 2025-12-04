# GAC (Git AI Commit)

🤖 AI-powered Git commit message generator - 让 AI 帮你写 commit message！

## ✨ 特性

- 🎯 **智能分析** - 自动分析 git diff，生成准确的 commit message
- 🌍 **多语言支持** - 支持中英文 commit message
- 📝 **Conventional Commits** - 支持标准的 commit 格式（feat, fix, docs 等）
- 🔧 **灵活配置** - 支持多种 AI 模型和 API 配置（Claude CLI 或 OpenAI 兼容接口）
- 💬 **交互式** - 可以确认、编辑或重新生成 commit message
- ⚡ **智能优化** - 大 diff 自动摘要，避免超出 token 限制

## 🚀 快速开始

### 1. 安装

```bash
# 进入项目目录
cd ~/project/gac

# 运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会：

- 将 `gac` 复制到 `~/bin`
- 创建配置文件模板到 `~/.config/gac.conf`

### 2. 配置

编辑 `~/.config/gac.conf`，添加你的 AI 模型配置。

#### 方式 1：使用 OpenAI 兼容接口（推荐）

支持 OpenAI、DeepSeek、Yunwu AI 等兼容接口：

```bash
AI_API_URL="https://yunwu.ai/v1/chat/completions"
AI_API_KEY="sk-..."
AI_MODEL="gpt-4o-mini"
```

#### 方式 2：使用 Claude CLI

如果你已安装并配置了 `claude` 命令行工具：

```bash
USE_CLAUDE_CLI=true
# 其他配置可留空，将使用环境变量
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
gac
```

就这么简单！AI 会分析你的改动并生成 commit message。

## 📖 使用示例

```bash
$ git add src/App.jsx
$ gac

ℹ️  Files changed: 1, Insertions: +23, Deletions: -5

ℹ️  Analyzing changes...
ℹ️  Using API endpoint: https://yunwu.ai/v1/chat/completions...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
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

## 🔧 高级用法

### Shell 函数快捷方式

你也可以在 `~/.bashrc` 或 `~/.zshrc` 中添加快捷函数：

```bash
# 快速 commit
function cmt() {
    git add .
    gac
}
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

## 📄 License

MIT License
