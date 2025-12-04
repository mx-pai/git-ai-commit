# GAC (Git AI Commit)

AI-powered Git commit message generator - 让 AI 帮你写 commit message。

## 特性

- **智能分析** - 自动分析 git diff，生成准确的 commit message
- **多语言支持** - 支持中英文 commit message
- **Conventional Commits** - 支持标准的 commit 格式（feat, fix, docs 等）
- **灵活配置** - 支持多种 AI 模型和 API 配置（Claude CLI 或 OpenAI 兼容接口）
- **交互式** - 可以确认、编辑或重新生成 commit message
- **智能优化** - 大 diff 自动摘要，避免超出 token 限制

## 安装要求

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

## 安装与配置

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

- 检查必需的依赖（jq、curl）
- 创建 `~/bin` 目录（如果不存在）
- 将 `gac` 脚本复制到 `~/bin/`
- 创建配置文件目录 `~/.config/`
- 将示例配置复制到 `~/.config/gac.conf`
- 设置执行权限

### 2. 添加到 PATH

确保 `~/bin` 在你的 PATH 环境变量中：

```bash
# 检查 PATH 是否包含 ~/bin
echo $PATH | grep -q "$HOME/bin" && echo "PATH 配置正确" || echo "需要配置 PATH"

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

## 配置详解

GAC 支持多种灵活的配置方式，适应不同的使用场景和需求。

### 快速配置（3分钟上手）

```bash
# 1. 复制配置文件
cp ~/project/gac/gac.conf.example ~/.config/gac.conf

# 2. 编辑并填写 API 信息
nano ~/.config/gac.conf

# 3. 测试配置
gac --config
```

### 配置方式（推荐顺序）

#### 方式 1：OpenAI 兼容 API

使用任意兼容 OpenAI Chat Completions 接口的云服务或本地服务：

```bash
# 示例：云端服务
AI_API_URL="https://api.example.com/v1/chat/completions"
AI_API_KEY="sk-你的密钥"
AI_MODEL="your-model-name"

# 示例：本地 Ollama
AI_API_URL="http://localhost:11434/v1/chat/completions"
AI_API_KEY="ollama"
AI_MODEL="your-local-model-name"
```

更多配置示例与说明 → [AI_CONFIGURATION.md](AI_CONFIGURATION.md)

#### 方式 2：环境变量（灵活覆盖）

环境变量优先于配置文件，适合临时切换：

```bash
# 临时使用其他模型
AI_MODEL="your-model-name" gac

# 使用本地模型（无网络）
AI_API_URL="http://localhost:11434/v1/chat/completions" \
AI_MODEL="your-local-model-name" \
gac

# 添加别名到 ~/.bashrc
alias gac-model='AI_MODEL="your-model-name" gac'
alias gac-local='AI_API_URL="http://localhost:11434/v1/chat/completions" AI_MODEL="your-local-model-name" gac'
```

#### 方式 3：Claude CLI（高级）

如果已安装 Claude CLI，可以使用：

```bash
USE_CLAUDE_CLI=true
ANTHROPIC_AUTH_TOKEN="sk-ant-xxx"  # 可选
ANTHROPIC_MODEL="claude-3-5-sonnet-20241022"  # 可选
```

安装：`pip install claude-cli`

#### 方式 4：多配置文件（高级）

在不同场景下切换配置文件：

```bash
# 创建多个配置文件
cp gac.conf.example ~/.config/gac-work.conf     # 工作配置
cp gac.conf.example ~/.config/gac-personal.conf # 个人配置
cp gac.conf.example ~/.config/gac-local.conf    # 本地配置

# 使用时指定
CONFIG_FILE=~/.config/gac-work.conf gac
CONFIG_FILE=~/.config/gac-local.conf gac
```

### 其他配置项

```bash
# Commit 消息语言
LANGUAGE="zh"  # zh=中文, en=英文

# Commit 格式
COMMIT_FORMAT="conventional"  # conventional 或 simple

# Diff 大小限制
MAX_DIFF_LINES=500

# 编辑器
EDITOR="nano"  # vim / code --wait / nano
```

### 配置验证

查看当前配置：
```bash
gac --config
```

配置有问题？查看 → [故障排查指南](#故障排查)
有兴趣深入了解？阅读 → [AI_CONFIGURATION.md](AI_CONFIGURATION.md)

我自己日常使用的 API 服务：https://yunwu.ai/register?aff=Ndh5 （仅供参考，请按需选择）

## 使用教程

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

```bash
# 添加新文件
git add src/components/LoginForm.tsx src/auth/api.ts

# 运行 GAC
gac

# 按提示确认或编辑生成的 commit message
```

### 处理大文件变更

当 diff 超过 `MAX_DIFF_LINES` 限制时：

```bash
$ gac

Diff is large (850 lines). Sending summary instead...
Files changed: 15, Insertions: +1250, Deletions: -380

# AI 将收到文件列表和统计信息，而不是完整的 diff
```

### 查看当前配置

```bash
# 查看配置信息
gac --config

# 输出示例：
# Current configuration from /home/user/.config/gac.conf:
# AI_API_URL="https://api.example.com/v1/chat/completions"
# AI_MODEL="your-model-name"
# LANGUAGE="zh"
# COMMIT_FORMAT="conventional"
# MAX_DIFF_LINES=500
```

## 高级用法

### 快捷函数

添加到 `~/.bashrc` 或 `~/.zshrc` 提升效率：

```bash
# 添加所有更改并提交（最常用）
cmt() { git add . && gac; }

# 添加、提交并推送到远程
cmp() { git add . && gac && git push; }

# 使用不同模型快速提交（示例）
cmt-model() { AI_MODEL="your-model-name" git add . && gac; }

# 使用本地模型（保护隐私）
cmt-local() { AI_API_URL="http://localhost:11434/v1/chat/completions" AI_MODEL="your-local-model-name" git add . && gac; }

# 预览 commit message（不提交）
gac-preview() { 
    git diff --cached > /tmp/gac-diff.txt
    cat /tmp/gac-diff.txt | gac --dry-run 2>/dev/null || echo "预览功能开发中"
}
```

**安装方式**：
- **Bash/Zsh**: 添加到 `~/.bashrc` 或 `~/.zshrc`
- **Fish**: 参考 [SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md#Fish-Shell)
- **PowerShell**: 参考 [SHELL_FUNCTIONS.md](SHELL_FUNCTIONS.md)

查看[完整快捷函数文档](SHELL_FUNCTIONS.md)了解更多实用函数。

### 多模型切换技巧

```bash
# 切换到不同的云端模型
AI_MODEL="your-model-name" gac
AI_MODEL="your-other-model-name" gac

# 切换到本地模型
AI_API_URL="http://localhost:11434/v1/chat/completions" AI_MODEL="your-local-model-name" gac

# Git 别名（可选）
git config --global alias.c '!git add -A && gac'
git config --global alias.cm '!git add -A && AI_MODEL="your-model-name" gac'
git config --global alias.cl '!git add -A && AI_API_URL="http://localhost:11434/v1/chat/completions" AI_MODEL="your-local-model-name" gac'
```

### 团队协作配置

在项目根目录创建 `.gacrc` 文件，统一团队配置：

```bash
# .gacrc - 项目级 GAC 配置
echo "# GAC project configuration" > .gacrc
echo "AI_API_URL='https://your-team-api.com/v1/chat/completions'" >> .gacrc
echo "AI_MODEL='your-model-name'" >> .gacrc
echo "LANGUAGE='zh'" >> .gacrc
echo "COMMIT_FORMAT='conventional'" >> .gacrc
```

团队成员使用：
```bash
source .gacrc && gac
```

详细使用技巧，请参考[完整使用指南](USAGE_GUIDE.md)


## 故障排查

查看 [USAGE_GUIDE.md](USAGE_GUIDE.md#troubleshooting) 获取详细的故障排查指南。

### 快速问题诊断

#### 问题 1：`gac: command not found`
```bash
# 检查 PATH
echo $PATH | grep -q "$HOME/bin" && echo "PATH 配置正确" || echo "需要配置 PATH"

# 添加到 PATH（如果缺失）
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### 问题 2：No AI model configured
```bash
# 查看当前配置
gac --config

# 检查 AI 配置
source ~/.config/gac.conf 2>/dev/null
if [[ -n "$USE_CLAUDE_CLI" ]]; then
    command -v claude &> /dev/null && echo "Claude CLI available" || echo "Claude CLI not found"
elif [[ -n "$AI_API_URL" && -n "$AI_API_KEY" ]]; then
    echo "API configured: ${AI_API_URL}"
    echo "Key set: ${AI_API_KEY:0:10}..."
else
    echo "No valid AI configuration"
fi
```

#### 问题 3：API 没有响应
```bash
# 测试网络连接
source ~/.config/gac.conf 2>/dev/null
if [[ -n "$AI_API_URL" ]]; then
    api_host=$(echo $AI_API_URL | cut -d'/' -f3)
    ping -c 1 $api_host &>/dev/null && echo "Network OK" || echo "Network issue"
fi

# 本地服务检查
if [[ "$AI_API_URL" == *"localhost"* || "$AI_API_URL" == *"127.0.0.1"* ]]; then
    curl -s $AI_API_URL &>/dev/null && echo "Local service running" || echo "Local service not responding"
fi

# 查看详细错误（调试模式）
bash -x ~/bin/gac 2>&1 | tail -20
```

#### 问题 4：模型返回错误或不合适的 message
```bash
# 切换到更合适的模型（示例）
AI_MODEL="your-model-name" gac              # 日常提交
AI_MODEL="your-other-model-name" gac       # 复杂更改
AI_MODEL="your-local-model-name" gac       # 使用本地模型

# 调整语言
LANGUAGE="zh" gac  # 强制中文
LANGUAGE="en" gac  # 强制英文

# 调整格式
COMMIT_FORMAT="simple" gac  # 简单格式
```

#### 问题 5：Ollama 本地模型无法连接
```bash
# 1. 检查 Ollama 状态
systemctl status ollama  # Linux
brew services list       # macOS

# 2. 测试 Ollama API
curl http://localhost:11434/api/tags  # 应该返回模型列表

# 3. 使用正确的配置
AI_API_URL="http://localhost:11434/v1/chat/completions" \
AI_API_KEY="ollama" \
AI_MODEL="your-local-model-name" \
gac
```

### 完整的快速测试

创建一个测试脚本来验证配置：

```bash
#!/bin/bash
echo "GAC Configuration Test"
echo "====================="

# 1. 检查基本命令
echo ""
echo "1. Command checks:"
command -v git &> /dev/null && echo "git: OK" || echo "git: not found"
command -v curl &> /dev/null && echo "curl: OK" || echo "curl: not found"
command -v jq &> /dev/null && echo "jq: OK" || echo "jq: not found"
command -v gac &> /dev/null && echo "gac: OK" || echo "gac: not found"

# 2. 检查 Git 仓库
echo ""
echo "2. Git repository:"
git rev-parse --git-dir &> /dev/null && echo "Git repository detected" || echo "Not in a git repository"

# 3. 检查配置
echo ""
echo "3. GAC configuration:"
if [[ -f ~/.config/gac.conf ]]; then
    echo "Config file exists: ~/.config/gac.conf"
    source ~/.config/gac.conf 2>/dev/null
else
    echo "No config file, will use environment variables"
fi

# 4. 检查 AI 配置
if [[ -n "${USE_CLAUDE_CLI:-}" ]]; then
    echo "Using Claude CLI"
    command -v claude &> /dev/null && echo "Claude CLI installed" || echo "Claude CLI not found"
elif [[ -n "${AI_API_URL:-}" && -n "${AI_API_KEY:-}" ]]; then
    echo "Using OpenAI-compatible API"
    echo "  URL: ${AI_API_URL}"
    echo "  Model: ${AI_MODEL:-<auto-detect>}"
else
    echo "No AI service configured"
    echo "  Run: cp ~/project/gac/gac.conf.example ~/.config/gac.conf"
    echo "  Then: nano ~/.config/gac.conf"
fi

# 5. Git 状态
echo ""
echo "4. Git status:"
git status --short | head -5
if git diff --cached --quiet; then
    echo "No staged changes (run: git add .)"
else
    echo "Staged changes ready for commit"
fi
```

将上述脚本保存为 `test-gac.sh`，然后运行：

```bash
chmod +x test-gac.sh
./test-gac.sh
```

查看完整指南了解详细解决方案和调试技巧。

## 贡献指南

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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新内容。

## Star 历史

如果喜欢这个项目，请给个 Star

[![Star History Chart](https://api.star-history.com/svg?repos=mx2004/gac&type=Date)](https://star-history.com/#mx2004/gac&Date)

## 联系方式

- 项目地址: [https://github.com/mx2004/gac](https://github.com/mx2004/gac)
- Issues: [提交问题](https://github.com/mx2004/gac/issues)
- 讨论: [开始讨论](https://github.com/mx2004/gac/discussions)
