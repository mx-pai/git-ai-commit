# GAC 详细使用指南

> GAC (Git AI Commit) 详细使用教程和最佳实践

## 📖 目录

1. [安装前准备](#安装前准备)
2. [安装步骤](#安装步骤)
3. [配置详解](#配置详解)
4. [基本使用](#基本使用)
5. [工作流程](#工作流程)
6. [高级用法](#高级用法)
7. [最佳实践](#最佳实践)
8. [常见问题](#常见问题)
9. [故障排查](#故障排查)
10. [使用场景](#使用场景)

---

## 一、安装前准备

### 系统要求

- **操作系统**: Linux, macOS, 或 WSL (Windows Subsystem for Linux)
- **Shell**: Bash 4.0+ 或兼容的 shell
- **内存**: 至少 512MB 可用内存
- **磁盘空间**: 至少 10MB 可用空间

### 必需依赖

在开始安装之前，请确保已经安装了以下软件：

| 软件 | 最低版本 | 检查命令 | 安装命令 (Ubuntu/Debian) |
|------|---------|----------|------------------------|
| Git | 2.0.0+ | `git --version` | `sudo apt install git` |
| Bash | 4.0.0+ | `bash --version` | 通常预装 |
| curl | 7.0.0+ | `curl --version` | `sudo apt install curl` |
| jq | 1.5+ | `jq --version` | `sudo apt install jq` |

### 安装依赖

#### Ubuntu/Debian 系统

```bash
# 更新软件包列表
sudo apt update

# 安装所有依赖
sudo apt install -y git curl jq

# 验证安装
echo "Git: $(git --version)"
echo "Bash: $(bash --version | head -n1)"
echo "curl: $(curl --version | head -n1)"
echo "jq: $(jq --version)"
```

#### macOS 系统

```bash
# 使用 Homebrew 安装
brew install git curl jq

# macOS 通常预装了 Bash，但可能版本较旧
# 如果需要更新 Bash
brew install bash

# 验证安装
echo "Git: $(git --version)"
echo "Bash: $(bash --version | head -n1)"
echo "curl: $(curl --version | head -n1)"
echo "jq: $(jq --version)"
```

#### CentOS/RHEL/Fedora

```bash
# 对于 CentOS/RHEL 7+
sudo yum install -y git curl jq

# 对于 Fedora
sudo dnf install -y git curl jq

# 验证安装
echo "Git: $(git --version)"
echo "Bash: $(bash --version | head -n1)"
echo "curl: $(curl --version | head -n1)"
echo "jq: $(jq --version)"
```

#### 验证所有依赖

运行以下脚本检查所有依赖：

```bash
#!/bin/bash
echo "🔍 检查 GAC 依赖..."

all_good=true

# 检查 Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version)"
else
    echo "❌ Git 未安装"
    all_good=false
fi

# 检查 Bash
if command -v bash &> /dev/null; then
    bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    if (( $(echo "$bash_version >= 4.0" | bc -l) )); then
        echo "✅ Bash: $(bash --version | head -n1)"
    else
        echo "❌ Bash 版本过低 (需要 4.0+，当前: $bash_version)"
        all_good=false
    fi
else
    echo "❌ Bash 未安装"
    all_good=false
fi

# 检查 curl
if command -v curl &> /dev/null; then
    echo "✅ curl: $(curl --version | head -n1)"
else
    echo "❌ curl 未安装"
    all_good=false
fi

# 检查 jq
if command -v jq &> /dev/null; then
    echo "✅ jq: $(jq --version)"
else
    echo "❌ jq 未安装"
    all_good=false
fi

if [ "$all_good" = true ]; then
    echo ""
    echo "🎉 所有依赖已满足！可以开始安装 GAC。"
else
    echo ""
    echo "⚠️  请安装缺失的依赖。"
    exit 1
fi
```

### AI 服务准备

GAC 需要 AI 服务来生成 commit message。你可以选择：

#### 选项 1：OpenAI 兼容 API（推荐）

- **OpenAI API**: 注册 [OpenAI](https://platform.openai.com/) 获取 API key
- **DeepSeek API**: 注册 [DeepSeek](https://platform.deepseek.com/) 获取 API key
- **Yunwu AI**: 注册 [云雾API](https://yunwu.ai/register?aff=Ndh5) 获取 API key
- **其他 OpenAI 兼容服务**

#### 选项 2：Claude CLI

- 安装 [Claude CLI](https://github.com/anthropics/claude-cli)
- 配置 API key 和端点

#### 选项 3：自建 AI 服务

- 部署自己的 OpenAI 兼容服务
- 获取 API 端点和 key

**建议**: 对于中文用户，推荐使用 云雾API 或 DeepSeek，响应速度和中文支持较好。

---

## 二、安装步骤

### 标准安装

```bash
# 1. 进入项目目录（假设你已下载或克隆项目）
cd ~/project/gac

# 2. 查看安装脚本内容（推荐）
cat install.sh

# 3. 添加执行权限
chmod +x install.sh

# 4. 运行安装脚本
./install.sh

# 5. 验证安装
gac --version
gac --help
```

### 安装脚本执行流程

安装脚本会执行以下步骤：

1. **检查依赖**: 验证 jq 和 curl 是否已安装
2. **创建目录**: 创建 ~/bin 目录（如果不存在）
3. **复制文件**: 将 gac 脚本复制到 ~/bin/
4. **设置权限**: 设置 gac 为可执行文件
5. **创建配置**: 创建 ~/.config/ 目录（如果不存在）
6. **复制配置**: 将 gac.conf.example 复制到 ~/.config/gac.conf

### 安装后验证

```bash
# 检查文件是否已创建
ls -la ~/bin/gac
ls -la ~/.config/gac.conf

# 检查 PATH 配置
echo $PATH | grep -q "$HOME/bin" && echo "✅ ~/bin 在 PATH 中" || echo "❌ 需要配置 PATH"

# 测试基本功能
gac --version  # 应该显示版本号
gac --help     # 应该显示帮助信息
gac --config   # 应该显示配置信息
```

### PATH 配置

如果 `~/bin` 不在 PATH 中，需要手动添加：

#### 对于 Bash 用户

```bash
# 编辑 ~/.bashrc
nano ~/.bashrc

# 在文件末尾添加
export PATH="$HOME/bin:$PATH"

# 保存并退出（Ctrl+X，然后 Y，然后 Enter）

# 重新加载配置
source ~/.bashrc

# 验证
echo $PATH
which gac
```

#### 对于 Zsh 用户

```bash
# 编辑 ~/.zshrc
nano ~/.zshrc

# 在文件末尾添加
export PATH="$HOME/bin:$PATH"

# 保存并退出

# 重新加载配置
source ~/.zshrc

# 验证
echo $PATH
which gac
```

#### 对于 Fish 用户

```bash
# 使用 fish 命令添加路径
set -U fish_user_paths $HOME/bin $fish_user_paths

# 验证
echo $PATH
which gac
```

### 卸载 GAC

如果需要卸载 GAC：

```bash
# 方法 1：使用卸载脚本（如果存在）
./install.sh uninstall

# 方法 2：手动删除
cd ~
rm -f ~/bin/gac
rm -f ~/.config/gac.conf

# 可选：从 PATH 中移除 ~/bin (编辑 ~/.bashrc 或 ~/.zshrc)
```

---

## 三、配置详解

### 配置文件结构

配置文件位于 `~/.config/gac.conf`，包含三个主要部分：

1. **AI Model Configuration** - AI 模型配置
2. **Commit Message Settings** - 提交消息设置
3. **Editor Settings** - 编辑器设置

### AI 模型配置详解

#### OpenAI 兼容接口配置

```bash
# ============================================================================
# AI Model Configuration
# ============================================================================

# API 端点 URL
AI_API_URL="https://yunwu.ai/v1/chat/completions"

# API 密钥
AI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# AI 模型名称
AI_MODEL="gpt-4o-mini"
```

**配置项说明**：

| 配置项 | 说明 | 示例 |
|--------|------|------|
| AI_API_URL | API 端点地址 | `https://yunwu.ai/v1/chat/completions` |
| AI_API_KEY | API 密钥 | `sk-...` |
| AI_MODEL | 模型名称 | `gpt-4o-mini`, `deepseek-chat` |

**常见 API 提供商配置**：

**1. Yunwu AI (推荐)**
```bash
AI_API_URL="https://yunwu.ai/v1/chat/completions"
AI_API_KEY="sk-..."
AI_MODEL="gpt-4o-mini"  # 或 gpt-4, claude-3.5-sonnet
```

**2. OpenAI**
```bash
AI_API_URL="https://api.openai.com/v1/chat/completions"
AI_API_KEY="sk-..."
AI_MODEL="gpt-4o-mini"  # 或 gpt-4, gpt-3.5-turbo
```

**3. DeepSeek**
```bash
AI_API_URL="https://api.deepseek.com/v1/chat/completions"
AI_API_KEY="sk-..."
AI_MODEL="deepseek-chat"  # 或 deepseek-coder
```

**4. 自建 API 服务**
```bash
AI_API_URL="https://your-api-server.com/v1/chat/completions"
AI_API_KEY="your-api-key"
AI_MODEL="your-model-name"
```

#### Claude CLI 配置

```bash
# 启用 Claude CLI
USE_CLAUDE_CLI=true

# Claude CLI 配置（可选）
ANTHROPIC_AUTH_TOKEN="your-api-key"  # 如果不设置，使用环境变量
ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"  # 自定义端点
ANTHROPIC_MODEL="GLM-4-Plus"  # 模型名称
```

**配置项说明**：

| 配置项 | 说明 | 是否必需 |
|--------|------|----------|
| USE_CLAUDE_CLI | 启用 Claude CLI | 是 |
| ANTHROPIC_AUTH_TOKEN | API 密钥 | 否（可使用环境变量） |
| ANTHROPIC_BASE_URL | 自定义 API 端点 | 否 |
| ANTHROPIC_MODEL | 模型名称 | 否 |

**安装和配置 Claude CLI**：

```bash
# 安装 Claude CLI
pip install claude-cli

# 或通过 GitHub
pip install git+https://github.com/anthropics/claude-cli.git

# 测试安装
claude --version

# 配置环境变量（如果不在 gac.conf 中设置）
export ANTHROPIC_AUTH_TOKEN="your-api-key"
export ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
export ANTHROPIC_MODEL="GLM-4-Plus"
```

### Commit Message 设置详解

#### 语言设置

```bash
# 语言设置："en" 或 "zh"
LANGUAGE="zh"
```

**选项说明**：

- `zh` - 中文 commit message（默认）
- `en` - 英文 commit message

**使用示例**：

```bash
# 中文示例（LANGUAGE="zh"）
feat(auth): 添加用户登录功能

# 英文示例（LANGUAGE="en"）
feat(auth): add user login functionality
```

#### Commit 格式设置

```bash
# Commit 格式："conventional" 或 "simple"
COMMIT_FORMAT="conventional"
```

**conventional 格式**：

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <description>

<body> (可选)

<footer> (可选)
```

**类型说明**：

| Type | 说明 | 中文示例 | 英文示例 |
|------|------|----------|----------|
| feat | 新功能 | feat(auth): 添加用户登录 | feat(auth): add user login |
| fix | Bug 修复 | fix(ui): 修复按钮样式 | fix(ui): fix button style |
| docs | 文档更新 | docs: 更新 README | docs: update README |
| style | 代码格式 | style: 格式化代码 | style: format code |
| refactor | 重构 | refactor: 优化用户服务 | refactor: optimize user service |
| test | 测试 | test: 添加登录测试 | test: add login test |
| chore | 构建/工具 | chore: 更新依赖 | chore: update dependencies |

**simple 格式**：

单行简单描述，不超过 50 个字符：

```
添加用户登录功能
修复登录按钮样式问题
```

#### Diff 大小限制

```bash
# 最大 diff 行数，超过此值将只发送摘要
MAX_DIFF_LINES=500
```

**工作原理**：

当 diff 行数超过 `MAX_DIFF_LINES` 时：
- 发送文件列表（name/status）
- 发送统计信息（stat）
- 不发送完整 diff 内容

**建议设置**：
- `200` - 严格限制，仅小改动
- `500` - 适中（默认）
- `1000` - 较大改动
- `2000` - 大改动

### 编辑器设置

```bash
# 编辑器设置（用于编辑 commit message）
# 默认使用 $EDITOR 环境变量，或 nano
EDITOR="nano"        # 使用 nano
EDITOR="vim"         # 使用 vim
EDITOR="code --wait" # 使用 VS Code
EDITOR="emacs"       # 使用 Emacs
```

**编辑器选项**：

| 编辑器 | 配置值 | 说明 |
|--------|--------|------|
| nano | `nano` | 简单易学，适合初学者 |
| vim | `vim` | 功能强大，需要学习曲线 |
| VS Code | `code --wait` | 图形界面，需要安装 |
| Emacs | `emacs` | 高度可定制 |
| Sublime Text | `subl -w` | 快速轻量 |

**设置 VS Code 为编辑器**：

```bash
# 确保 VS Code 已安装并配置在 PATH 中
which code

# 在 gac.conf 中设置
EDITOR="code --wait"

# 或者设置环境变量
export EDITOR="code --wait"
```

### 配置验证

```bash
# 查看当前配置
gac --config

# 验证配置是否加载
source ~/.config/gac.conf
echo "API URL: $AI_API_URL"
echo "AI Model: $AI_MODEL"
echo "Language: $LANGUAGE"
echo "Commit Format: $COMMIT_FORMAT"

# 测试 API 连接
# 创建一个测试脚本
cat > test_ai.sh << 'EOF'
#!/bin/bash
source ~/.config/gac.conf

if [[ -n "${AI_API_URL:-}" ]] && [[ -n "${AI_API_KEY:-}" ]]; then
    echo "Testing API connection..."
    response=$(curl -s "${AI_API_URL}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${AI_API_KEY}" \
        -d '{
            "model": '""${AI_MODEL:-gpt-3.5-turbo}""',
            "messages": [{"role": "user", "content": "Say hello"}],
            "max_tokens": 10
        }')
    
    if echo "$response" | grep -q "hello\|Hello"; then
        echo "✅ API 连接成功！"
    else
        echo "❌ API 连接失败：$response"
    fi
else
    echo "❌ API 配置不完整"
fi
EOF

chmod +x test_ai.sh
./test_ai.sh
rm test_ai.sh
```

---

## 四、基本使用

### 命令格式

```bash
gac [选项]

选项：
  -h, --help     显示帮助信息
  -v, --version  显示版本信息
  -c, --config   显示当前配置
```

### 标准工作流程

```bash
# 1. 添加文件到暂存区
git add <file1> <file2> ...

# 2. 运行 GAC 生成 commit message
gac

# 3. 根据提示操作
#    - [y] 使用当前 message
#    - [e] 编辑 message
#    - [r] 重新生成
#    - [n] 取消

# 4. 成功提交！
```

### 使用示例

#### 示例 1：添加新功能

```bash
# 添加新功能文件
git add src/components/NewFeature.tsx src/utils/helper.ts

# 运行 GAC
$ gac

ℹ️  Files changed: 2, Insertions: +156, Deletions: -0

ℹ️  Analyzing changes...
ℹ️  Using API endpoint: https://yunwu.ai/v1/chat/completions...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(auth): 添加用户登录功能

- 实现邮箱密码登录
- 添加表单验证
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
# 修复了多个文件中的 bug
git add src/pages/Dashboard.jsx src/api/data.js

$ gac

ℹ️  Files changed: 2, Insertions: +8, Deletions: -15

ℹ️  Analyzing changes...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
fix(dashboard): 修复数据加载错误

- 修复 API 响应解析
- 处理空数据情况
- 添加错误边界
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: e  # 选择编辑

# 编辑器打开，你可以修改内容
# 例如改为：

fix(dashboard): 修复数据加载时的空指针异常

修复当 API 返回空数据时导致的页面崩溃问题

- 添加 null 检查
- 显示友好的错误提示
- 添加单元测试

# 保存并退出
✅ Committed with edited message!
```

#### 示例 3：文档更新

```bash
# 更新文档
git add README.md docs/API.md

$ gac

ℹ️  Files changed: 2, Insertions: +45, Deletions: -12

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
docs: 更新 README 和 API 文档

- 添加新的接口说明
- 修复示例代码错误
- 更新环境变量配置说明
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: y
✅ Committed successfully!
```

#### 示例 4：代码重构

```bash
# 重构多个文件
git add src/services/user.js src/services/auth.js src/utils/validation.js

$ gac

ℹ️  Files changed: 3, Insertions: +234, Deletions: -189

⚠️  Diff is large (650 lines). Sending summary instead...

ℹ️  Analyzing changes...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
refactor(services): 重构用户服务模块

- 提取公共函数到工具模块
- 优化错误处理逻辑
- 统一 API 响应格式
- 删除重复代码
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: r  # 重新生成

ℹ️  Regenerating... (attempt 2)
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
refactor: 重构用户认证和验证服务

优化代码结构和可维护性

- 将用户相关逻辑提取到独立服务
- 统一认证流程
- 改进验证工具函数
- 更新相关测试
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: y
✅ Committed successfully!
```

### 交互式选项详解

当 GAC 生成 commit message 后，你有 4 个选项：

#### 选项 [y] - 使用当前 message

直接提交当前生成的 commit message。

```bash
Your choice: y
✅ Committed successfully!
```

**适用场景**: 
- Message 准确描述了更改
- 不需要额外修改
- 快速提交

#### 选项 [e] - 编辑 message

打开编辑器修改 commit message。

```bash
Your choice: e

# 编辑器打开，显示当前的 commit message
# 你可以：
# 1. 修改标题
# 2. 添加详细说明
# 3. 添加 issue 编号（如 #123）
# 4. 添加 Co-authored-by 信息

# 保存并退出后提交
✅ Committed with edited message!
```

**编辑建议**: 
- 保持标题简洁（< 50 字符）
- 正文详细说明更改原因
- 添加 Breaking Changes 说明（如需要）

**适用场景**: 
- 需要添加更多上下文
- 需要添加 issue 编号
- 需要调整描述
- 需要添加 Co-author

#### 选项 [r] - 重新生成

让 AI 重新生成 commit message。

```bash
Your choice: r

ℹ️  Regenerating... (attempt 2)
ℹ️  Analyzing changes...
...

Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 新的 message
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your choice: y
✅ Committed successfully!
```

**适用场景**: 
- 当前 message 不满意
- 想尝试不同的描述
- 第一次生成不够准确

#### 选项 [n] - 取消

取消本次提交。

```bash
Your choice: n
ℹ️  Commit cancelled.
```

文件仍然保留在暂存区，可以稍后重新提交。

**适用场景**: 
- 需要重新组织更改
- 需要拆分提交
- 暂时不想提交

---

## 五、工作流程

### 开发工作流程

#### 1. 特性开发流程

```bash
# 开始新特性
git checkout -b feature/user-profile

# 开发过程中多次提交
git add src/components/Profile.jsx
gac
# 选择 [y] 提交

git add src/utils/user.js
gac
# 选择 [e] 编辑，添加详细说明

# 完成特性
git add tests/profile.test.js
gac
# 选择 [r] 重新生成，直到满意

# 推送到远程
git push origin feature/user-profile

# 创建 Pull Request
```

#### 2. Bug 修复流程

```bash
# 创建修复分支
git checkout -b fix/login-error

# 修复 bug
git add src/auth/login.js
gac
# AI 生成：fix(auth): 修复登录错误

# 添加测试
git add tests/login.test.js
gac
# AI 生成：test(auth): 添加登录错误处理测试

# 提交修复
git add src/api/error-handler.js
gac
# 选择 [e] 添加：相关 issue #123

# 合并到主分支
git checkout main
git merge fix/login-error
```

#### 3. 文档更新流程

```bash
# 文档分支
git checkout -b docs/update-readme

# 更新文档
git add README.md docs/API.md
gac
# AI 生成：docs: 更新 README 和 API 文档

# 添加截图或示例
git add docs/images/screenshot.png
gac
# 选择 [e] 添加：展示新 UI 界面

# 快速提交
git add docs/CHANGELOG.md
gac
# 选择 [y] 直接提交
```

### 团队协作流程

#### 1. 代码审查准备

```bash
# 确保 commit message 清晰
# 在提交前检查每个 commit

git log --oneline -5
# 确保每个 message 都清晰描述了更改

# 如果需要修改历史 commit，使用
git rebase -i HEAD~3
# 在编辑器中重新组织或修改 message
```

#### 2. Pull Request 准备

```bash
# 1. 同步主分支
git checkout main
git pull origin main

# 2. 在特性分支上 rebase
git checkout feature/my-feature
git rebase main

# 3. 解决冲突时，每个冲突解决后提交
git add src/conflict-file.js
gac
# AI 生成：fix(merge): 解决冲突

# 4. 推送到远程
git push -f origin feature/my-feature

# 5. 创建 Pull Request，AI 生成的清晰 message 有助于审查
```

#### 3. 代码合并

```bash
# 合并特性分支
git checkout main
git merge --no-ff feature/my-feature

# 如果合并提交需要 message，手动编辑
gac
# 或直接使用 git
```

### 个人开发流程

#### 1. 每日工作流

```bash
# 1. 开始工作
git pull origin main
git checkout -b feature/today-task

# 2. 开发过程中
git add .
gac
# 查看生成的 message，选择 [y] 或 [e]

# 3. 继续开发
git add .
gac

# 4. 每天结束
git push origin feature/today-task
```

#### 2. 实验性开发

```bash
# 实验分支
git checkout -b experiment/new-idea

# 快速迭代
git add .
gac
# 频繁提交，message 自动生成

# 实验完成，整理 commit
git log --oneline
git rebase -i HEAD~5
# 合并相关的 commit

# 合并到主分支
git checkout main
git merge experiment/new-idea --squash
gac
# 生成总结性的 commit message
```

---

## 六、高级用法

### 1. 环境变量覆盖

可以在运行时临时覆盖配置：

```bash
# 临时使用英文
LANGUAGE=en gac

# 临时使用简单格式
COMMIT_FORMAT=simple gac

# 临时切换 API
gac
AI_API_URL="https://api.openai.com/v1/chat/completions" gac

# 组合使用
LANGUAGE=en COMMIT_FORMAT=simple AI_MODEL="gpt-3.5-turbo" gac
```

### 2. 自定义快捷键

在 `~/.bashrc` 或 `~/.zshrc` 中添加：

```bash
# Git + GAC 组合
alias ga="git add ."
alias gc="gac"
alias gacp="git add . && gac && git push"

# 快速提交
cmt() {
    git add .
    gac
}

# 提交并推送
cmtp() {
    git add .
    gac && git push
}

# 只对暂存的文件提交
gacs() {
    # 检查是否有暂存的更改
    if git diff --cached --quiet; then
        echo "⚠️  没有暂存的更改。请使用 'git add' 先暂存文件。"
        return 1
    fi
    gac
}

# 跳过 AI 生成，手动输入
git_manual() {
    git add .
    git commit
}

# 生成 message 但不提交（用于复制）
gac_preview() {
    git add .
    temp_file=$(mktemp)
    gac 2>&1 | tee "$temp_file"
    # 提取 message
    sed -n '/Generated Commit Message:/,/━━━━━━━━━━━━━━━━/p' "$temp_file" | \
        sed '1d;$d' | pbcopy  # macOS
        # xclip -selection clipboard  # Linux
    echo "📋 Message copied to clipboard!"
    rm "$temp_file"
}
```

添加后重新加载配置：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

### 3. Git 钩子集成

在 `.git/hooks/prepare-commit-msg` 中使用 GAC：

```bash
#!/bin/bash
# .git/hooks/prepare-commit-msg

# 仅在 message 来自模板时运行
if [ "$2" = "template" ] || [ "$2" = "merge" ]; then
    return 0
fi

# 检查是否有暂存的更改
if ! git diff --cached --quiet; then
    # 生成 commit message
    COMMIT_MSG_FILE=$1
    TEMP_FILE=$(mktemp)
    
    # 运行 gac 并将输出捕获到临时文件
    gac 2>&1 | tee "$TEMP_FILE"
    
    # 提取 commit message
    sed -n '/Generated Commit Message:/,/━━━━━━━━━━━━━━━━/p' "$TEMP_FILE" | \
        sed '1d;$d' > "$COMMIT_MSG_FILE"
    
    rm "$TEMP_FILE"
fi
```

设置钩子权限：

```bash
chmod +x .git/hooks/prepare-commit-msg
```

### 4. 多项目配置

为不同项目使用不同的配置：

```bash
# 创建项目特定的配置
mkdir -p ~/project/gac_configs
cp ~/.config/gac.conf ~/project/gac_configs/work.conf
cp ~/.config/gac.conf ~/project/gac_configs/personal.conf
cp ~/.config/gac.conf ~/project/gac_configs/open-source.conf

# 修改各自的配置
nano ~/project/gac_configs/work.conf
# 设置工作项目的 API key 和设置

nano ~/project/gac_configs/personal.conf
# 设置个人项目的 API key 和设置

nano ~/project/gac_configs/open-source.conf
# 设置开源项目的 API key 和设置
```

使用项目配置：

```bash
# 在项目中创建 .gacrc 或类似的脚本
cat > .gacrc << 'EOF'
#!/bin/bash
# Source this file to use project-specific GAC config
export CONFIG_FILE="$HOME/project/gac_configs/work.conf"
echo "Using project GAC config: $CONFIG_FILE"
EOF

# 使用方法
source .gacrc
gac

# 或者直接在项目中设置
CONFIG_FILE="$HOME/project/gac_configs/work.conf" gac
```

### 5. IDE 集成

#### VS Code 集成

在 `.vscode/tasks.json` 中：

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "AI Commit",
            "type": "shell",
            "command": "gac",
            "problemMatcher": [],
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "shared"
            },
            "group": {
                "kind": "build",
                "isDefault": false
            }
        }
    ]
}
```

使用方法：
- 按 `Ctrl+Shift+P` (或 `Cmd+Shift+P` on Mac)
- 输入 "Run Task"
- 选择 "AI Commit"

#### WebStorm / IntelliJ

在 "External Tools" 中配置：

1. 打开 Settings → Tools → External Tools
2. 点击 "+" 添加新工具
3. 配置：
   - Name: GAC AI Commit
   - Program: /home/user/bin/gac
   - Working directory: $ProjectFileDir$
   - 勾选 "Open console" 和 "Show console when standard out changes"
4. 可以配置快捷键

### 6. API 响应处理

GAC 使用 curl 和 jq 处理 API 响应。了解这个流程有助于调试：

```bash
# API 请求流程
1. 构建 JSON payload (使用 jq)
2. 发送 POST 请求 (使用 curl)
3. 解析响应 (使用 jq)
4. 提取 message content
5. 显示给用户

# 错误处理
# - 空响应 → 显示错误
# - API 错误 → 显示错误消息
# - 网络错误 → 显示连接失败
```

可以通过环境变量调试：

```bash
# 显示 curl 详细信息
export CURL_VERBOSE=1
gac

# 保存 API 请求和响应
export GAC_DEBUG=1
# 这将保存请求和响应到 /tmp/gac_debug_*.json
```

---

## 七、最佳实践

### 1. Commit Message 最佳实践

#### 1.1 使用 Conventional Commits

```bash
# 好的示例
feat(auth): 添加 JWT 认证
docs: 更新 API 文档
fix(ui): 修复移动端布局问题
refactor(utils): 优化日期处理函数

# 不好的示例
update
fix bug
add some features
done
```

#### 1.2 清晰的 Scope

```bash
# 使用具体的作用域
feat(auth): 添加 OAuth2 登录
feat(api): 添加用户列表接口
fix(ui/header): 修复导航菜单样式
refactor(utils/date): 改进日期格式化

# 避免过于宽泛的作用域
feat(ALL): ...
fix(app): ...
refactor(code): ...
```

#### 1.3 详细的 Body

```bash
# 当需要解释 "why" 而不是 "what" 时添加 body
feat(auth): 实现单点登录

- 使用 OAuth2 协议集成企业认证
- 支持 SAML 2.0 标准
- 减少用户重复登录
- 相关 issue: #456

# 简单的更改不需要 body
docs: 修复拼写错误
```

### 2. 提交频率

#### 2.1 建议的提交频率

- **功能开发**: 每个逻辑单元提交一次（30分钟-2小时）
- **Bug 修复**: 每个 bug 独立提交
- **重构**: 每个重构步骤提交一次
- **文档**: 每个文档页面或章节提交一次

#### 2.2 避免过大的提交

```bash
❌ 不好的做法：
# 一次性提交多个不相关的更改
git add .
gac
# 生成的 message 可能过于宽泛

✅ 好的做法：
# 提交 1: 添加新功能
git add src/components/NewFeature.jsx
gac
# message: feat(ui): 添加新功能组件

# 提交 2: 更新相关文档
git add docs/FEATURES.md README.md
gac
# message: docs: 更新功能文档

# 提交 3: 添加测试
git add tests/NewFeature.test.js
gac
# message: test(ui): 添加新功能组件测试
```

### 3. 分支策略与 GAC

#### 3.1 Git Flow

```bash
# Feature 分支
feat/some-new-feature
# → commit: feat: 添加新功能

# Bugfix 分支  
fix/critical-bug
# → commit: fix: 修复严重 bug

# Hotfix 分支
hotfix/security-issue
# → commit: fix(security): 修复安全漏洞
```

#### 3.2 GitHub Flow

```bash
# 每个 PR 对应一个分支
git checkout -b fix-issue-123
gac
git push origin fix-issue-123
# 在 PR 中说明：fix: 修复问题 #123
```

### 4. API 使用优化

#### 4.1 选择合适的模型

```bash
# 快速开发时使用更快的模型
AI_MODEL="gpt-3.5-turbo"  # 更快、更便宜

# 重要提交使用更好的模型
AI_MODEL="gpt-4"  # 更准确、更智能

# 根据更改大小选择
if [ $(git diff --cached --numstat | wc -l) -gt 10 ]; then
    export AI_MODEL="gpt-4"
else
    export AI_MODEL="gpt-3.5-turbo"
fi
```

#### 4.2 优化 API 成本

```bash
# 减少 MAX_DIFF_LINES 节省 token
MAX_DIFF_LINES=300

# 使用摘要模式处理大改动
# 手动触发：
git add .
gac  # AI 会自动使用摘要

# 对于超大项目，进一步减少
git diff --cached --name-only > /tmp/files.txt
git diff --cached --stat > /tmp/stats.txt
# 将文件内容发送给 API
```

### 5. 安全性最佳实践

#### 5.1 保护 API Key

```bash
# ❌ 不要在代码中硬编码 API key
# ❌ 不要提交包含 API key 的文件

# ✅ 使用配置文件
echo "gac.conf" >> .gitignore

# ✅ 使用环境变量
export AI_API_KEY="sk-..."

# ✅ 使用权限控制
chmod 600 ~/.config/gac.conf  # 仅自己可读
```

#### 5.2 敏感代码处理

```bash
# 如果 diff 包含敏感信息
# 1. 先检查 diff
git diff --cached

# 2. 如果发现敏感信息
git reset HEAD <敏感文件>
# 编辑文件移除敏感信息

# 3. 重新添加和提交
git add <文件>
gac
```

### 6. 大型项目处理

#### 6.1 分批提交

```bash
# 对于大型重构
# 方法 1: 按模块提交
git add src/module-a/
gac && git commit -m "refactor(module-a): 重构模块 A"

git add src/module-b/
gac && git commit -m "refactor(module-b): 重构模块 B"

# 方法 2: 按类型提交
git add src/*.js
gac && git commit -m "refactor(scripts): 更新 JavaScript 文件"

git add src/*.css
gac && git commit -m "style: 更新样式文件"
```

#### 6.2 处理大文件

```bash
# 如果项目包含大文件
# 配置 git-lfs
git lfs install
git lfs track "*.psd"
git lfs track "*.zip"

# 提交时，GAC 会处理 diff 摘要
git add large-file.psd
gac
# ⚠️ Diff is large, sending summary
```

### 7. 与 CI/CD 集成

#### 7.1 检查 Commit Message

在 CI 中验证 commit message 格式：

```yaml
# .github/workflows/commitlint.yml
name: Commitlint
on: [push, pull_request]
jobs:
  commitlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Check commit message format
        run: |
          npm install -g @commitlint/cli @commitlint/config-conventional
          echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
          commitlint --from=HEAD~1 --to=HEAD
```

由于 GAC 生成符合规范的 message，这个检查通常能顺利通过。

#### 7.2 自动生成 Changelog

```bash
# 使用 conventional commits 生成 changelog
npm install -g conventional-changelog-cli

# 生成 changelog
conventional-changelog -p angular -i CHANGELOG.md -s

# GAC 生成的 message 格式兼容此工具
```

### 8. 团队规范

#### 8.1 团队配置模板

为团队创建共享配置模板：

```bash
# team-gac.conf
cat > team-gac.conf << 'EOF'
# 团队 GAC 配置

# 使用团队的 API (可选)
# AI_API_URL="https://team-api.example.com/v1/chat/completions"
# AI_API_KEY="team-key"

# 统一语言
LANGUAGE="zh"

# 统一格式
COMMIT_FORMAT="conventional"

# 团队约定
# - feat: 新功能
# - fix: Bug 修复
# - docs: 文档
# - style: 样式
# - refactor: 重构
# - test: 测试
# - chore: 构建、工具
EOF

# 团队成员复制配置
cp team-gac.conf ~/.config/gac.conf
```

#### 8.2 Code Review 检查项

Review 时检查：

- [ ] Commit message 清晰描述了更改
- [ ] Type 和 scope 选择恰当
- [ ] Breaking changes 有明确标注
- [ ] 每个 commit 大小适中
- [ ] 没有 "WIP", "tmp", "fix" 等模糊 message

---

## 八、常见问题

### Q1: GAC 支持哪些 AI 模型？

**A**: GAC 支持任何 OpenAI 兼容接口，包括：
- OpenAI GPT-3.5, GPT-4
- DeepSeek
- Claude (通过 Claude CLI)
- 自建 OpenAI 兼容服务

### Q2: 如何处理 API key 泄露？

**A**: 
1. 立即删除泄露的 commit：`git reset --hard <before-leak>`
2. 修改 API key
3. 更新配置文件
4. 如果已推送到远程，需要强制推送

### Q3: GAC 能否处理二进制文件？

**A**: GAC 主要分析文本 diff。对于二进制文件：
- 在 diff 中只显示文件名
- AI 会根据文件名和上下文生成 message
- 建议在 message 中说明添加了什么二进制文件

### Q4: 如何自定义 commit message 模板？

**A**: 
- GAC 自动生成基于 diff 的 message
- 通过 `COMMIT_FORMAT` 可以选择 conventional 或 simple
- 通过编辑功能可以在生成后手动调整
- 如果需要完全自定义，考虑 fork 项目并修改 `build_prompt` 函数

### Q5: GAC 会存储我的代码吗？

**A**: 
- GAC 不存储代码，只发送 diff 给 AI API
- 代码安全性取决于你使用的 AI 服务
- 使用私有部署的 AI 服务可以确保代码不泄露

### Q6: 如何处理合并冲突？

**A**: 
1. 解决冲突后：`git add <resolved-files>`
2. 运行 `gac`
3. AI 会生成描述冲突解决的消息
4. 通常 message 类似：`fix(merge): 解决分支合并冲突`

### Q7: GAC 支持 monorepo 吗？

**A**: 支持。对于 monorepo：
- 在根目录运行会处理所有子项目的更改
- 建议按子项目分别提交：
  ```bash
  git add packages/auth/
  gac
  # message: feat(auth): ...
  
  git add packages/ui/
  gac
  # message: feat(ui): ...
  ```

### Q8: 如何禁用 GAC 的交互提示？

**A**: 
- GAC 目前设计为交互式工具
- 如果需要非交互模式，可以使用脚本：
  ```bash
  echo "y" | gac
  ```
- 或在 `.bashrc` 中添加：
  ```bash
  gac_auto() {
      gac <<< "y"
  }
  ```

### Q9: GAC 在 Windows 上能运行吗？

**A**: 
- GAC 是为 Linux/macOS 设计的 bash 脚本
- 在 Windows 上可以使用 WSL (Windows Subsystem for Linux)
- 或使用 Git Bash，但可能有问题
- 推荐在 WSL 中使用

### Q10: 如何贡献代码到 GAC 项目？

**A**: 
1. Fork 项目
2. 创建特性分支
3. 进行修改
4. 使用 GAC 生成 commit message
5. 提交 Pull Request
6. 在 PR 中说明更改

### Q11: 为什么 AI 生成的 message 不够准确？

**A**: 
- 检查 diff 是否清晰：小且集中的更改效果更好
- 尝试重新生成：选择 [r] 重新生成
- 编辑改进：选择 [e] 手动优化
- 考虑切换 AI 模型：更好的模型理解更准确
- 大型重构：手动拆分提交

### Q12: GAC 支持 Git 子模块吗？

**A**: 
- 在主项目中可以正常使用
- 在子模块中需要分别运行
- 建议先在子模块提交，再在主项目提交

```bash
# 在子模块
cd submodule
git add .
gac
git push

# 在主项目
cd ..
git add submodule
gac  # 提交子模块更新
```

---

## 九、故障排查

### 安装问题

#### 问题：安装后 gac 命令未找到

**症状**：
```bash
$ gac --version
bash: gac: command not found
```

**排查步骤**：

1. 检查文件是否存在：
   ```bash
   ls -la ~/bin/gac
   ```

2. 检查 PATH：
   ```bash
   echo $PATH | grep -q "$HOME/bin" && echo "✅ 在 PATH 中" || echo "❌ 不在 PATH 中"
   ```

3. 检查执行权限：
   ```bash
   ls -la ~/bin/gac | grep -q "-rwxr" && echo "✅ 有执行权限" || echo "❌ 无执行权限"
   ```

4. 验证文件内容：
   ```bash
   head -5 ~/bin/gac
   ```

**解决方案**：

- 如果文件不存在：重新运行 `./install.sh`
- 如果不在 PATH 中：添加到 .bashrc 或 .zshrc
- 如果没有执行权限：`chmod +x ~/bin/gac`

#### 问题：依赖检查失败

**症状**：
```bash
Error: jq is required but not installed
```

**排查步骤**：

```bash
# 检查 jq
command -v jq &> /dev/null && echo "✅ jq 已安装" || echo "❌ jq 未安装"

# 检查 curl
command -v curl &> /dev/null && echo "✅ curl 已安装" || echo "❌ curl 未安装"
```

**解决方案**：

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y jq curl

# macOS
brew install jq curl

# CentOS/RHEL
sudo yum install -y jq curl
```

### 配置问题

#### 问题：配置文件未找到

**症状**：
```bash
⚠️  No configuration file found at /home/user/.config/gac.conf
```

**排查步骤**：

1. 检查配置文件：
   ```bash
   ls -la ~/.config/gac.conf
   ```

2. 检查默认配置：
   ```bash
   ls -la gac.conf.example
   ```

3. 检查目录权限：
   ```bash
   ls -ld ~/.config/
   ```

**解决方案**：

```bash
# 如果配置文件不存在
# 方法 1: 手动创建从示例复制
cp ~/project/gac/gac.conf.example ~/.config/gac.conf

# 方法 2: 重新安装
./install.sh

# 编辑配置
nano ~/.config/gac.conf
```

#### 问题：配置未生效

**症状**：
- 修改了配置文件但 GAC 行为未改变
- 配置看起来没有加载

**排查步骤**：

1. 验证配置文件语法：
   ```bash
   bash -n ~/.config/gac.conf
   ```

2. 检查配置文件内容：
   ```bash
   cat ~/.config/gac.conf
   ```

3. 验证变量加载：
   ```bash
   source ~/.config/gac.conf
echo "MODEL: $AI_MODEL"
echo "LANGUAGE: $LANGUAGE"
   ```

4. 检查 GAC 加载逻辑：
   ```bash
   bash -x ~/bin/gac --config 2>&1 | grep -A 5 "CONFIG_FILE"
   ```

**解决方案**：

```bash
# 1. 修复配置文件语法错误
nano ~/.config/gac.conf

# 2. 确保使用的变量名称正确
#    AI_API_URL (正确)
#    AI-API-URL (错误)

# 3. 检查是否有语法错误
#    变量赋值不能有空格：VAR="value" (正确)
#    变量赋值不能有空格：VAR = "value" (错误)
```

### API 问题

#### 问题：AI 模型没有响应

**症状**：
```bash
❌ Error: Failed to get response from AI model
```

**排查步骤**：

1. 验证 API 配置：
   ```bash
   source ~/.config/gac.conf
echo "URL: $AI_API_URL"
echo "Key: ${AI_API_KEY:0:10}..."
echo "Model: $AI_MODEL"
   ```

2. 测试网络连接：
   ```bash
   source ~/.config/gac.conf
curl -I "${AI_API_URL}" 2>&1 | head -5
   ```

3. 测试 API 调用：
   ```bash
   source ~/.config/gac.conf
curl -s "${AI_API_URL}" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${AI_API_KEY}" \
     -d '{"model": '""${AI_MODEL:-gpt-3.5-turbo}""', "messages": [{"role": "user", "content": "test"}], "max_tokens": 10}'
   ```

4. 如果使用 Claude CLI：
   ```bash
claude --version
claude "test"
   ```

**解决方案**：

- 检查 API key 是否过期
- 检查 API 端点是否正确
- 检查网络连接
- 检查账户余额（如果使用付费服务）
- 如果使用 Claude CLI，确保已正确配置

#### 问题：API 响应解析失败

**症状**：
```bash
❌ Error: Failed to parse AI response
```

**排查步骤**：

1. 启用调试模式：
   ```bash
   # 修改 gac 脚本，在 call_ai_model 函数中添加
   echo "DEBUG: API Response: $response" >&2
   ```

2. 检查 jq 版本：
   ```bash
   jq --version
   ```

3. 手动测试解析：
   ```bash
   echo '{"choices":[{"message":{"content":"test"}}]}' | jq -r '.choices[0].message.content'
   ```

**解决方案**：

- 更新 jq 到最新版本
- 检查 API 响应格式是否有变化
- 更新 GAC 脚本以适应新的响应格式

### Git 相关问题

#### 问题：No staged changes found

**症状**：
```bash
❌ Error: No staged changes found. Please stage your changes first with 'git add'
```

**排查步骤**：

1. 检查 Git 状态：
   ```bash
   git status
   ```

2. 检查暂存的文件：
   ```bash
   git diff --cached --name-only
   ```

3. 检查是否有更改：
   ```bash
   git diff --name-only
   ```

**解决方案**：

```bash
# 如果有未暂存的更改
git add .

# 然后运行 gac
gac
```

#### 问题：Not a git repository

**症状**：
```bash
❌ Error: Not a git repository
```

**排查步骤**：

1. 检查当前目录：
   ```bash
   pwd
   ```

2. 检查 Git 目录：
   ```bash
   ls -la | grep .git
   ```

3. 检查是否在子目录：
   ```bash
   git rev-parse --git-dir
   ```

**解决方案**：

```bash
# 进入正确的项目目录
cd /path/to/your/project

# 或者如果是新项目，初始化 Git
git init
```

#### 问题：Commit 失败

**症状**：
```bash
❌ Error: Commit failed
```

**排查步骤**：

1. 检查 Git 配置：
   ```bash
   git config --list
   ```

2. 检查是否有 pre-commit 钩子失败：
   ```bash
   cat .git/hooks/pre-commit
   ```

3. 检查 commit template：
   ```bash
   git config commit.template
   ```

**解决方案**：

```bash
# 检查身份信息
git config user.name
git config user.email

# 如果未设置
if [ -z "$(git config user.name)" ]; then
    git config user.name "Your Name"
fi
if [ -z "$(git config user.email)" ]; then
    git config user.email "your.email@example.com"
fi

# 手动测试 commit
git commit -m "test"
```

### 性能问题

#### 问题：GAC 运行缓慢

**症状**：
- 运行 `gac` 需要很长时间才有响应
- AI 分析过程很慢

**排查步骤**：

1. 检查 diff 大小：
   ```bash
   git diff --cached | wc -l
   ```

2. 检查网络延迟：
   ```bash
   source ~/.config/gac.conf
   ping -c 4 $(echo $AI_API_URL | sed 's|https://||' | sed 's|/.*||')
   ```

3. 检查 API 响应时间：
   ```bash
time curl -s "${AI_API_URL}" ...
   ```

**解决方案**：

```bash
# 1. 减小 MAX_DIFF_LINES
MAX_DIFF_LINES=300

# 2. 使用更快的模型
AI_MODEL="gpt-3.5-turbo"

# 3. 分批提交
# 不要一次性提交大量文件

# 4. 检查网络连接
# 使用更快的网络或更近的 API 端点
```

#### 问题：编辑器未打开

**症状**：
选择 [e] 编辑后，编辑器未打开或报错

**排查步骤**：

1. 检查编辑器配置：
   ```bash
   source ~/.config/gac.conf
echo "EDITOR: $EDITOR"
   ```

2. 测试编辑器：
   ```bash
   $EDITOR --version
   ```

3. 测试临时文件：
   ```bash
   tmp=$(mktemp)
echo "test" > $tmp
$EDITOR $tmp
rm $tmp
   ```

**解决方案**：

```bash
# 如果编辑器未安装或不可用
# 在 gac.conf 中修改为可用的编辑器
EDITOR="nano"  # 几乎在所有系统上都可用
```

### 调试技巧

#### 启用详细日志

```bash
# 启动 bash 调试模式
bash -x $(which gac) 2>&1 | tee gac_debug.log

# 分析日志
grep -E "(Error|Failed|DEBUG)" gac_debug.log
```

#### 模拟 API 响应

```bash
# 创建一个 mock API
#!/bin/bash
echo '{"choices":[{"message":{"content":"test commit message"}}]}'

# 在 gac 中临时替换
# 修改 call_ai_model 函数
```

#### 手动测试 prompt

```bash
# 获取当前的 diff
git diff --cached > /tmp/current_diff.txt

# 构建 prompt
LANGUAGE="zh" COMMIT_FORMAT="conventional"
# 使用 build_prompt 函数逻辑手动构建

# 保存并测试
cat /tmp/prompt.txt | claude --dangerously-skip-permissions
```

---

## 十、使用场景

### 场景 1：初创公司快速开发

**背景**: 快速迭代，多人协作，需要清晰的 commit history

**配置**: 
```bash
# ~/.config/gac.conf
AI_API_URL="https://yunwu.ai/v1/chat/completions"
AI_MODEL="gpt-4o-mini"  # 平衡速度和成本
LANGUAGE="zh"
COMMIT_FORMAT="conventional"
MAX_DIFF_LINES=500
```

**工作流程**: 
```bash
# 开发者工作流程
git checkout -b feature/new-module
git add .
gac
git push origin feature/new-module
# Code Review → Merge
```

**优势**: 
- 自动规范 commit message
- 新成员容易上手
- 生成 changelog 方便

### 场景 2：开源项目维护

**背景**: 接受社区贡献，需要清晰的 commit 历史

**配置**: 
```bash
# 使用英文，国际化
LANGUAGE="en"
COMMIT_FORMAT="conventional"
# 使用更严格的模型确保质量
AI_MODEL="gpt-4"
```

**规范**: 
```bash
# PR 模板中要求使用 GAC
# .github/pull_request_template.md
- [ ] 使用 GAC 生成 commit message
- [ ] 遵循 Conventional Commits 规范
- [ ] 添加必要的测试
```

**优势**: 
- 统一的 commit 风格
- 自动生成的 message 更准确
- 便于自动生成 release notes

### 场景 3：大型企业项目

**背景**: 多团队，多模块，严格的代码审查

**配置**: 
```bash
# 企业 API 端点
AI_API_URL="https://internal-ai.company.com/v1/chat/completions"
# 企业级安全
LANGUAGE="en"
COMMIT_FORMAT="conventional"
MAX_DIFF_LINES=300  # 严格限制提交大小
EDITOR="code --wait"  # 统一编辑器
```

**工作流程**: 
```bash
# 严格的提交流程
git checkout -b feature/module-x-improvement
# 开发...git add src/module-x/
gac  # 生成 message
git push origin feature/module-x-improvement
# 多级 Code Review → QA → Merge
```

**优势**: 
- 合规的提交记录
- 便于审计和回溯
- 统一的团队协作标准

### 场景 4：个人项目

**背景**: 个人开发，快速迭代，记录开发过程

**配置**: 
```bash
# 使用便宜的 API 或本地模型
AI_API_URL="https://yunwu.ai/v1/chat/completions"
AI_MODEL="gpt-3.5-turbo"  # 成本低
LANGUAGE="zh"  # 中文更习惯
COMMIT_FORMAT="conventional"
```

**工作流程**: 
```bash
# 快速开发
git add .
gac
git push
```

**优势**: 
- 养成规范的提交习惯
- 项目历史清晰
- 未来找工作有良好展示

### 场景 5：教育和培训

**背景**: 教授学生 Git 和协作开发

**使用**: 
```bash
# 教学配置
LANGUAGE="zh"
COMMIT_FORMAT="conventional"  # 强制规范

# 练习学生
git checkout -b student-assignment
git add .
gac
# 让学生理解为什么这样写 message
```

**优势**: 
- 学习行业最佳实践
- 自动规范减少错误
- 专注于代码逻辑而非 message 格式

---

## 📚 总结

GAC (Git AI Commit) 是一个强大的工具，能够：

1. **自动化**: 自动生成符合规范的 commit message
2. **标准化**: 统一团队的提交风格
3. **效率提升**: 减少思考 message 的时间
4. **质量改进**: 清晰的 commit history 便于维护

### 快速开始

```bash
# 1. 安装依赖 (Ubuntu/Debian)
sudo apt install git curl jq

# 2. 安装 GAC
cd ~/project/gac
./install.sh

# 3. 配置
nano ~/.config/gac.conf
# 添加 API key 和相关设置

# 4. 使用
git add .
gac

# 5. 享受 AI 生成的 commit message!
```

### 最佳实践回顾

1. **经常提交**: 小的、清晰的提交
2. **适当编辑**: 虽然 AI 生成，但需要时应该编辑
3. **团队规范**: 统一配置，统一风格
4. **保护密钥**: 不要将 API key 提交到仓库
5. **定期审查**: 检查 commit history 的质量

### 支持

- **文档**: [README.md](README.md)
- **问题**: [Issues](https://github.com/mx2004/gac/issues)
- **讨论**: [Discussions](https://github.com/mx2004/gac/discussions)

---

感谢使用 GAC 🚀 让 AI 帮你写出更好的 commit message！
