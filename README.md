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

在 `~/.bashrc` 或 `~/.zshrc` 中添加常用快捷方式：

```bash
# 快速提交所有修改
function cmt() {
    git add .
    gac
}

# 提交并推送
function cmp() {
    git add .
    gac && git push
}

# 只提交已暂存的更改（不自动 add）
function gacstaged() {
    gac
}

# 生成 commit message 但不提交（用于复制粘贴）
function gacpreview() {
    git add .
    echo "$(gac --dry-run 2>&1 | grep -A 100 "Generated Commit Message:" | tail -n +4)"
}
```

添加后重新加载配置：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

### Git 别名

配置 Git 别名以便更方便使用：

```bash
git config --global alias.c '!git add -A && gac'
git config --global alias.ac '!git add . && gac'
git config --global alias.cmt '!gac'
```

使用：

```bash
git c   # add all 并生成 commit message
git ac  # 同上
git cmt # 只对已暂存的更改生成 commit message
```

### 多语言切换

快速切换语言（无需修改配置文件）：

```bash
# 临时使用英文
LANGUAGE=en gac

# 临时使用中文
LANGUAGE=zh gac

# 在 shell 配置中添加别名
alias gac-en="LANGUAGE=en gac"
alias gac-zh="LANGUAGE=zh gac"
```

### 不同 commit 格式

```bash
# 使用简单格式（单行）
COMMIT_FORMAT=simple gac

# 使用 conventional 格式
COMMIT_FORMAT=conventional gac
```

### 配合其他 Git 工具

#### 配合 Git 工作流

```bash
# Feature 分支开发
git checkout -b feature/user-authentication
git add .
gac

# Bug 修复
git checkout -b fix/login-bug
git add .
gac

# Hotfix
git checkout -b hotfix/security-patch
git add .
gac
```

#### 配合 Git GUI

如果你使用 Git GUI 工具（如 GitKraken、SourceTree），可以：

1. 在 GUI 中进行代码更改
2. 在终端中运行 `gac` 生成 commit message
3. 复制生成的 message 到 GUI 中使用

## 🛠️ 故障排查

### 常见问题

#### 问题 1：AI 模型没有响应

**症状**: 运行 `gac` 后显示 "Failed to get response from AI model"

**解决方法**:

1. **检查 API key**：
   ```bash
   cat ~/.config/gac.conf | grep AI_API_KEY
   # 确保 key 正确且未过期
   ```

2. **测试 API 连通性**：
   ```bash
   # 替换为你的 API URL 和 key
   curl -H "Authorization: Bearer sk-..." \
        https://yunwu.ai/v1/models
   ```

3. **检查网络连接**：
   ```bash
   ping yunwu.ai
   ```

4. **如果使用 Claude CLI**：
   ```bash
   claude --version
   # 检查版本 ≥ 0.5.0
   claude "test"
   # 测试 CLI 是否正常工作
   ```

5. **查看详细错误信息**：
   ```bash
   # 临时启用调试输出
   bash -x $(which gac) 2>&1 | tail -20
   ```

#### 问题 2：`~/bin` 不在 PATH 中

**症状**: 运行 `gac` 时显示 "command not found"

**解决方法**:

1. **检查 PATH**：
   ```bash
   echo $PATH
   ```

2. **添加到 PATH**：
   ```bash
   # 对于 Bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 对于 Zsh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 对于 Fish
set -U fish_user_paths $HOME/bin $fish_user_paths
```

3. **直接使用完整路径**：
   ```bash
~/bin/gac
```

#### 问题 3：No staged changes found

**症状**: 运行 `gac` 后显示 "No staged changes found"

**原因**: 需要先使用 `git add` 暂存更改

**解决方法**:

```bash
# 添加所有更改的文件
git add .

# 或者添加特定文件
git add src/main.js tests/main.test.js

# 再次运行 gac
gac
```

#### 问题 4：Not a git repository

**症状**: 运行 `gac` 后显示 "Not a git repository"

**原因**: 当前目录不是 Git 仓库

**解决方法**:

```bash
# 检查当前目录
pwd

# 如果你已经在 git 仓库中，检查 .git 目录
ls -la | grep .git

# 初始化 Git 仓库（如果是新项目）
git init

# 进入正确的项目目录
cd /path/to/your/project
```

#### 问题 5：Empty commit message

**症状**: 编辑 commit message 后提交失败

**原因**: 编辑后保存空内容

**解决方法**:

1. 重新运行 `gac`
2. 选择 "[e] Edit this message"
3. 确保保存非空内容
4. 或者直接使用 "[y] Use this message"

#### 问题 6：Diff too large

**症状**: 较大的 diff 可能影响 AI 生成质量

**解决方法**:

1. **分批提交**：
   ```bash
   # 只提交部分文件
git add src/components/*.jsx
gac

git add src/utils/*.js
gac
```

2. **调整 MAX_DIFF_LINES**：
   ```bash
   # 在 ~/.config/gac.conf 中
   MAX_DIFF_LINES=1000
   ```

3. **使用交互式 add**：
   ```bash
   git add -p  # 逐个补丁添加，选择重要的更改
   gac
   ```

#### 问题 7：jq 或 curl 未找到

**症状**: 运行 `gac` 后显示 "jq: command not found" 或 "curl: command not found"

**解决方法**:

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install jq curl

# macOS
brew install jq curl

# CentOS/RHEL
sudo yum install jq curl

# 验证安装
jq --version
curl --version
```

### 高级调试

#### 启用详细输出

```bash
# 使用 bash -x 查看详细执行过程
bash -x $(which gac) 2>&1 | less

# 查看配置文件加载
bash -x $(which gac) --config
```

#### 测试 API 连接

```bash
# 创建一个测试脚本
cat > test_api.sh << 'EOF'
#!/bin/bash
source ~/.config/gac.conf

echo "Testing API connection to: $AI_API_URL"
echo "Using model: $AI_MODEL"

# 测试请求
response=$(curl -s "${AI_API_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${AI_API_KEY}" \
  -d '{
    "model": '""$AI_MODEL""',
    "messages": [{"role": "user", "content": "Say 'hello'"}],
    "max_tokens": 10
  }')

echo "Response: $response"
echo ""
echo "Parsed message: $(echo "$response" | jq -r '.choices[0].message.content // .content // "Failed"' 2>/dev/null)"
EOF

chmod +x test_api.sh
./test_api.sh
```

#### 检查配置文件

```bash
# 验证配置文件存在且可读
ls -la ~/.config/gac.conf

# 查看配置文件内容
cat ~/.config/gac.conf

# 测试配置文件语法
bash -n ~/.config/gac.conf

# 验证变量设置
source ~/.config/gac.conf
echo "URL: $AI_API_URL"
echo "Model: $AI_MODEL"
echo "Language: $LANGUAGE"
```

### 性能优化

#### 加快 commit 速度

1. **使用更快的模型**：
   ```bash
   # 在 ~/.config/gac.conf 中
   AI_MODEL="gpt-3.5-turbo"  # 比 gpt-4 更快
   ```

2. **减少 MAX_DIFF_LINES**：
   ```bash
   MAX_DIFF_LINES=300  # 减少发送的数据量
   ```

3. **使用 Claude CLI**（本地运行更快）：
   ```bash
   USE_CLAUDE_CLI=true
   ```

#### 缓存配置

在 `~/.bashrc` 或 `~/.zshrc` 中预加载配置：

```bash
# 预加载 GAC 配置（如果在 git 仓库中）
if [[ -f ~/.config/gac.conf ]] && [[ -d .git ]]; then
    source ~/.config/gac.conf
fi
```

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
