# GAC (Git AI Commit)

🤖 AI-powered Git commit message generator - 让 AI 帮你写 commit message！

## ✨ 特性

- 🎯 **智能分析** - 自动分析 git diff，生成准确的 commit message
- 🌍 **多语言支持** - 支持中英文 commit message
- 📝 **Conventional Commits** - 支持标准的 commit 格式（feat, fix, docs 等）
- 🔧 **灵活配置** - 支持多种 AI 模型和 API 配置（Claude CLI 或 OpenAI 兼容接口）
- 💬 **交互式** - 可以确认、编辑或重新生成 commit message
- ⚡ **智能优化** - 大 diff 自动摘要，避免超出 token 限制

## 📋 安装要求

在开始使用 GAC 之前，请确保你的系统满足以下要求：

### 必需依赖

- **Git** - 版本 2.0 或更高
- **Bash** - 版本 4.0 或更高
- **curl** - 用于 API 调用
- **jq** - 用于处理 JSON 响应

### 安装依赖

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install git curl jq
```

#### macOS (使用 Homebrew)
```bash
brew install git curl jq
```

#### CentOS/RHEL
```bash
sudo yum install git curl jq
```

#### 验证安装
```bash
git --version
curl --version
jq --version
```

## 🚀 安装与配置

### 1. 安装 GAC

进入项目目录并运行安装脚本：

```bash
# 进入项目目录（已存在）
cd ~/project/gac

# 运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会执行以下操作：

- 🔍 检查必需的依赖（jq、curl）
- 📂 创建 `~/bin` 目录（如果不存在）
- 💾 将 `gac` 脚本复制到 `~/bin/`
- ⚙️ 创建配置文件目录 `~/.config/`
- 📝 将示例配置复制到 `~/.config/gac.conf`
- ©️ 设置执行权限

### 2. 添加到 PATH

确保 `~/bin` 在你的 PATH 环境变量中：

```bash
# 检查 PATH 是否包含 ~/bin
echo $PATH | grep -q "$HOME/bin" && echo "✅ PATH 配置正确" || echo "❌ 需要配置 PATH"

# 如果不在 PATH 中，添加到 shell 配置
# 对于 ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 对于 ~/.zshrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 3. 验证安装

```bash
gac --version
gac --help
```

## ⚙️ 配置详解

编辑配置文件 `~/.config/gac.conf`，根据你的需求进行自定义：

```bash
# 打开配置文件
nano ~/.config/gac.conf
```

### AI 模型配置

#### 方式 1：使用 OpenAI 兼容接口（推荐）

支持 OpenAI、DeepSeek、Yunwu AI 等兼容接口：

```bash
# API 端点
AI_API_URL="https://yunwu.ai/v1/chat/completions"  # 或你的 API 地址

# API 密钥
AI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# AI 模型名称
AI_MODEL="gpt-4o-mini"  # 支持的模型：gpt-4, gpt-3.5-turbo, deepseek-chat 等
```

**常用的 API 提供商：**

- **OpenAI**: `https://api.openai.com/v1/chat/completions`
- **DeepSeek**: `https://api.deepseek.com/v1/chat/completions`
- **Yunwu AI**: `https://yunwu.ai/v1/chat/completions`
- **自定义 OpenAI 兼容接口** - 修改为你的接口地址

#### 方式 2：使用 Claude CLI

如果你已安装并配置了 `claude` 命令行工具：

```bash
USE_CLAUDE_CLI=true

# 可选的环境变量
ANTHROPIC_AUTH_TOKEN="your-api-key"  # 如果不设置将使用环境变量
ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"  # 自定义端点
ANTHROPIC_MODEL="GLM-4-Plus"  # 模型名称
```

#### 方式 3：环境变量配置

你也可以直接在环境变量中设置：

```bash
# 在 ~/.bashrc 或 ~/.zshrc 中添加
export AI_API_URL="https://yunwu.ai/v1/chat/completions"
export AI_API_KEY="sk-..."
export AI_MODEL="gpt-4o-mini"
```

### Commit 消息设置

```bash
# 语言设置
LANGUAGE="zh"  # zh=中文, en=英文

# Commit 格式
COMMIT_FORMAT="conventional"  # conventional 或 simple

# Diff 大小限制
MAX_DIFF_LINES=500  # 超过此值将只发送文件列表和统计信息
```

### 编辑器设置

```bash
# 编辑 commit message 时使用的编辑器
# 默认使用 $EDITOR 环境变量，或 nano
EDITOR="vim"        # 使用 vim
EDITOR="code --wait" # 使用 VS Code
EDITOR="nano"       # 使用 nano
```

## 🎯 使用教程

### 基本工作流程

```bash
# 1. 添加要提交的文件
git add <file1> <file2> ...
# 或者添加所有修改
git add .

# 2. 运行 GAC
gac

# 3. AI 分析变更并生成 commit message
# 4. 确认、编辑或重新生成
# 5. 提交成功！
```

### 完整使用示例

#### 示例 1：添加新功能

```bash
# 添加新文件
git add src/components/LoginForm.tsx src/auth/api.ts

# 运行 GAC
$ gac

ℹ️  Files changed: 2, Insertions: +156, Deletions: -0

ℹ️  Analyzing changes...
ℹ️  Using API endpoint: https://yunwu.ai/v1/chat/completions...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(auth): 添加用户登录表单组件

- 实现邮箱/密码登录表单
- 添加表单验证逻辑
- 集成认证 API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Options:
  [y] Use this message
  [e] Edit this message
  [r] Regenerate message
  [n] Cancel

Your choice: y
✅ Committed successfully!
```

#### 示例 2：修复 Bug

```bash
# 修改了多个文件
git add src/utils/date.ts src/components/Calendar.jsx

$ gac

ℹ️  Files changed: 2, Insertions: +12, Deletions: -8

ℹ️  Analyzing changes...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
fix(utils): 修复日期格式化函数

- 正确处理跨月日期计算
- 修复闰年判断逻辑
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: e  # 选择编辑
# 编辑器打开，你可以修改 commit message

✅ Committed with edited message!
```

#### 示例 3：文档更新

```bash
git add README.md docs/API.md

$ gac

ℹ️  Files changed: 2, Insertions: +45, Deletions: -12

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
docs: 更新 API 文档和 README

- 添加新的接口说明
- 修复示例代码错误
- 更新环境变量配置说明
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: r  # 重新生成

ℹ️  Regenerating... (attempt 2)
...
```

### 处理大文件变更

当 diff 超过 `MAX_DIFF_LINES` 限制时：

```bash
$ gac

⚠️  Diff is large (850 lines). Sending summary instead...
ℹ️  Files changed: 15, Insertions: +1250, Deletions: -380

# AI 将收到文件列表和统计信息，而不是完整的 diff
```

### 查看当前配置

```bash
# 查看配置信息
gac --config

# 输出示例：
# ℹ️  Current configuration from /home/user/.config/gac.conf:
# AI_API_URL="https://yunwu.ai/v1/chat/completions"
# AI_MODEL="gpt-4o-mini"
# LANGUAGE="zh"
# COMMIT_FORMAT="conventional"
# MAX_DIFF_LINES=500
```

## 🔧 高级用法

### 快捷函数

GAC 提供了一系列实用的快捷函数，提升日常使用效率：

```bash
cmt          # 添加所有更改并提交（最常用）
cmp          # 添加、提交并推送到远程
gac-preview  # 预览 commit message（不提交）
```

**安装方式**：
- **Bash/Zsh**: 添加到 `~/.bashrc` 或 `~/.zshrc`
- **Fish**: 参考 [SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md#Fish-Shell)
- **PowerShell**: 参考 [SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md)

查看[完整快捷函数文档](SHELL_FUNCTIONS.md)了解更多实用函数。

### 使用技巧

```bash
# 切换语言
LANGUAGE=en gac    # 英文
LANGUAGE=zh gac    # 中文

# 切换格式  
COMMIT_FORMAT=simple gac      # 简单格式
COMMIT_FORMAT=conventional gac  # 标准格式（默认）

# Git 别名（可选）
git config --global alias.c '!git add -A && gac'
```

详细使用技巧，请参考[完整使用指南](USAGE_GUIDE.md)


## 🛠️ 故障排查

遇到问题？查看 [USAGE_GUIDE.md](USAGE_GUIDE.md#九故障排查) 获取详细的故障排查指南。

常见问题：
- 🔧 AI 模型没有响应
- 🔧 `gac` 命令未找到
- 🔧 No staged changes
- 🔧 Not a git repository
- 🔧 jq/curl 命令未找到

查看完整指南了解详细解决方案和调试技巧。

## 🤝 贡献指南

欢迎贡献！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

### 快速开始贡献

1. Fork 项目
2. 创建特性分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git add . && ./gac`
4. 推送到分支：`git push origin feature/amazing-feature`
5. 开启 Pull Request

### 开发环境设置

```bash
# 克隆项目
git clone https://github.com/your-username/gac.git
cd gac

# 创建开发配置
cp gac.conf.example gac.conf.dev
nano gac.conf.dev

# 使用开发配置运行
CONFIG_FILE="./gac.conf.dev" ./gac
```

### 测试

```bash
# 运行基本测试
make test

# 手动测试命令
./gac --version
./gac --help
./gac --config
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

我用的 API 代理：[云雾API](https://yunwu.ai/register?aff=Ndh5)， 你也可以试试吧

## 📝 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新内容。

## ⭐ Star 历史

如果喜欢这个项目，请给个 Star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=mx2004/gac&type=Date)](https://star-history.com/#mx2004/gac&Date)

## 📞 联系方式

- 项目地址: [https://github.com/mx2004/gac](https://github.com/mx2004/gac)
- Issues: [提交问题](https://github.com/mx2004/gac/issues)
- 讨论: [开始讨论](https://github.com/mx2004/gac/discussions)
