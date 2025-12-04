# GAC 详细使用指南

> GAC (Git AI Commit) 使用教程和实践说明  
> 面向已了解 Git 的用户，重点介绍安装、配置和日常使用。

## 目录

1. [一、安装前准备](#install-prereqs)
2. [二、安装步骤](#install-steps)
3. [三、配置详解](#configuration)
4. [四、基本使用](#basic-usage)
5. [五、工作流程](#workflow)
6. [六、高级用法](#advanced-usage)
7. [七、最佳实践](#best-practices)
8. [八、常见问题](#faq)
9. [九、故障排查](#troubleshooting)
10. [十、使用场景](#use-cases)
11. [总结](#summary)

---

<a id="install-prereqs"></a>
## 一、安装前准备

### 系统和工具要求

- 操作系统：Linux、macOS，或 WSL (Windows Subsystem for Linux)
- Shell：Bash 4.0+ 或兼容的 shell
- 依赖工具：
  - Git 2.0+
  - curl
  - jq

快速检查：

```bash
git --version
curl --version
jq --version
```

如缺失，可按系统使用包管理器安装（例如 Ubuntu/Debian 中 `sudo apt install git curl jq`），详细安装命令可参考 README。

---

<a id="install-steps"></a>
## 二、安装步骤

假设你已经克隆了仓库：

```bash
git clone https://github.com/mx2004/gac.git
cd gac
```

### 安装 GAC

```bash
chmod +x install.sh
./install.sh
```

安装脚本会完成：

1. 检查 `curl`、`jq` 等依赖  
2. 创建 `~/bin` 并复制 `gac` 脚本  
3. 创建配置目录 `~/.config/` 并生成示例配置 `~/.config/gac.conf`

### 将 GAC 加入 PATH

确认 `~/bin` 已在 `PATH` 中：

```bash
echo "$PATH" | grep -q "$HOME/bin" && echo "PATH 包含 ~/bin" || echo "PATH 需加入 ~/bin"
```

如需添加（以 Bash 为例）：

```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 验证安装

```bash
gac --version
gac --help
```

如显示版本和帮助信息，说明安装成功。

---

<a id="configuration"></a>
## 三、配置详解

GAC 的配置主要通过：

- 配置文件：`~/.config/gac.conf`
- 环境变量：运行命令前临时覆盖配置

环境变量优先级高于配置文件。

### 3.1 AI 服务配置

GAC 通过 AI 服务生成提交信息，推荐使用 OpenAI 兼容接口，或基于 Claude CLI 的本地工具。

#### OpenAI 兼容 API

最小配置示例：

```bash
AI_API_URL="https://api.example.com/v1/chat/completions"
AI_API_KEY="sk-your-api-key"
AI_MODEL="your-model-name"
```

只要服务兼容 `POST /v1/chat/completions`，一般只需要配置以上三个变量即可。  
服务商、模型选择和更完整示例见 `AI_CONFIGURATION.md`。

#### Claude CLI

如果已经使用 Claude CLI，可以通过它生成提交信息：

```bash
USE_CLAUDE_CLI=true

# 可选：通过环境变量或配置文件指定
ANTHROPIC_AUTH_TOKEN="your-api-key"
ANTHROPIC_BASE_URL="https://api.anthropic.com"
ANTHROPIC_MODEL="your-claude-model-name"
```

GAC 只依赖 Claude CLI 提供的命令行接口，安装和鉴权方式以 Claude CLI 官方文档为准。

### 3.2 Commit Message 设置

在 `gac.conf` 中可以控制生成的提交信息风格：

```bash
# 语言：zh / en
LANGUAGE="zh"

# 提交格式：conventional / simple
COMMIT_FORMAT="conventional"

# 最大 diff 行数，超过后只发送摘要而不是完整 diff
MAX_DIFF_LINES=500
```

- `LANGUAGE`：控制生成中文或英文的提交信息  
- `COMMIT_FORMAT`：  
  - `conventional`：符合 Conventional Commits 规范  
  - `simple`：单行简要描述

### 3.3 编辑器设置

当你选择编辑提交信息时，GAC 会使用配置中的编辑器：

```bash
EDITOR="nano"        # 或 vim / code --wait / emacs 等
```

如不设置，默认遵循 `$EDITOR` 环境变量或系统默认编辑器。

---

<a id="basic-usage"></a>
## 四、基本使用

### 标准流程

在任意 Git 仓库中：

```bash
git add <file1> <file2> ...
# 或
git add .

gac
```

GAC 会：

1. 检查当前仓库与暂存区状态  
2. 收集 `git diff --cached` 等信息  
3. 调用配置的 AI 服务生成提交信息  
4. 进入交互式确认：
   - `[y]` 使用当前信息并提交  
   - `[e]` 打开编辑器修改  
   - `[r]` 重新生成  
   - `[n]` 取消本次提交

### 快速示例

```bash
# 添加新文件
git add src/foo.ts

# 生成并确认提交信息
gac
```

通常的推荐用法是先让 AI 生成，再根据需要使用 `[e]` 手动补充背景信息、issue 编号等。

---

<a id="workflow"></a>
## 五、工作流程

本节总结在日常开发中使用 GAC 的常见方式。

### 5.1 特性开发

```bash
git checkout -b feature/my-feature

# 开发过程中分阶段提交
git add src/module-a/*
gac      # 描述模块 A 改动

git add src/module-b/*
gac      # 描述模块 B 改动

git push origin feature/my-feature
```

每个 commit 尽量对应一个相对独立的改动，便于 AI 生成清晰的说明，也便于后续回溯。

### 5.2 Bug 修复

```bash
git checkout -b fix/bug-123

git add .
gac      # 通常生成以 fix(...) 开头的提交信息

git push origin fix/bug-123
```

建议在需要时通过 `[e]` 补充“为什么这样修”和相关 issue 号。

---

<a id="advanced-usage"></a>
## 六、高级用法

本节只列出常用的高级能力，详细脚本示例可以参考 `SHELL_FUNCTIONS.md`。

### 6.1 使用环境变量临时覆盖配置

```bash
# 当前命令使用英文 + simple 格式
LANGUAGE=en COMMIT_FORMAT=simple gac

# 临时切换模型
AI_MODEL="your-model-name" gac

# 使用本地服务
AI_API_URL="http://localhost:11434/v1/chat/completions" \
AI_API_KEY="ollama" \
AI_MODEL="your-local-model-name" \
gac
```

适合：

- 临时使用更强/更弱的模型  
- 在某次提交中切换语言或提交格式  
- 本地模型和云端模型之间切换

### 6.2 Shell 快捷函数

在 `~/.bashrc` 或 `~/.zshrc` 中添加简单封装：

```bash
# 添加所有更改并提交
cmt() { git add . && gac; }

# 添加、提交并推送
cmp() { git add . && gac && git push; }
```

更多 Bash / Zsh / Fish / PowerShell 的快捷函数见 `SHELL_FUNCTIONS.md`。

### 6.3 多配置文件

可以为不同场景准备不同配置文件，例如工作 / 个人 / 本地模型：

```bash
cp ~/project/gac/gac.conf.example ~/.config/gac-work.conf
cp ~/project/gac/gac.conf.example ~/.config/gac-personal.conf

# 使用时指定
CONFIG_FILE=~/.config/gac-work.conf gac
CONFIG_FILE=~/.config/gac-personal.conf gac
```

---

<a id="best-practices"></a>
## 七、最佳实践

这里汇总一些在实际使用中较常见、也比较通用的建议。

### 7.1 提交粒度

- 每次提交覆盖一个清晰的逻辑改动  
- 避免单个提交混合“功能 + 重构 + 格式化”等多种类型  
- 较大的重构建议拆成多个提交（比如先重命名/移动文件，再修改逻辑）

### 7.2 提交信息风格

使用 `COMMIT_FORMAT="conventional"` 时，建议遵循 Conventional Commits 规范，例如：

```text
feat(auth): add login API
fix(ui): 修复按钮样式
docs: 更新 README
refactor: 重构用户服务
test: 添加单元测试
chore: 更新依赖
```

可以通过 `[e]` 编辑补充为什么要做这次修改，而不仅仅是“做了什么”。

### 7.3 安全与隐私

- 不要在仓库中提交包含 API key 的配置文件  
- 建议把 `gac.conf` 加入 `.gitignore`  
- 对敏感仓库（内部代码、隐私数据），优先考虑本地模型或企业内部服务

---

<a id="faq"></a>
## 八、常见问题

本节只列出使用层面的几个常见问题，配置和服务相关的问题详见 `AI_CONFIGURATION.md`。

### 8.1 支持哪些 AI 服务？

GAC 支持：

- 任意兼容 OpenAI Chat Completions 接口的服务  
- 通过 Claude CLI 间接使用 Claude 模型  
- 自建的 OpenAI 兼容服务或本地模型（如 Ollama）

关键是保证：

- `AI_API_URL` 指向兼容的 `/v1/chat/completions` 接口  
- `AI_API_KEY`、`AI_MODEL` 设置正确

### 8.2 是否会上传完整代码？

- GAC 会基于 `git diff --cached` 生成提交信息  
- 发送给 AI 服务的内容通常是 diff，必要时会做行数截断或摘要  
- 是否存储、如何使用这些数据取决于你选择的服务商  
- 如对隐私有较高要求，可使用本地模型或内部部署的服务

### 8.3 可以单独使用 GAC 生成信息但不提交吗？

当前主命令是交互式提交流程，如果只是想参考信息，可以：

```bash
git add .
gac    # 生成后选择 [n] 取消提交
```

或者编写简单脚本，将生成的信息写入临时文件，具体可参考项目 issue/讨论中的示例。

---

<a id="troubleshooting"></a>
## 九、故障排查

遇到问题时，建议先按以下顺序排查。

### 9.1 `gac: command not found`

检查安装位置和 PATH：

```bash
ls -la ~/bin/gac
echo "$PATH" | grep "$HOME/bin"
```

- 如文件不存在，重新运行 `./install.sh`  
- 如 `~/bin` 不在 PATH 中，按前文“安装步骤”部分添加

### 9.2 No AI model configured / 调用失败

确认配置文件存在且内容生效：

```bash
ls -la ~/.config/gac.conf
gac --config
```

如仍有问题，可手动测试 API：

```bash
source ~/.config/gac.conf

curl -s "$AI_API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${AI_API_KEY}" \
  -d '{"model":"'"${AI_MODEL:-your-model-name}"'","messages":[{"role":"user","content":"test"}],"max_tokens":10}'
```

如果返回错误信息，优先检查：

- URL、API key 是否正确  
- 模型名称是否存在  
- 网络和代理配置

### 9.3 No staged changes found

GAC 只会针对暂存区的改动生成提交信息，如提示没有暂存更改，可以：

```bash
git status
git add .
gac
```

确认需要提交的文件已经通过 `git add` 加入暂存区。

### 9.4 Not a git repository

确保当前目录是 Git 仓库：

```bash
git rev-parse --git-dir
```

如提示不是仓库，可以：

- 切换到已有仓库目录  
- 或运行 `git init` 初始化新仓库再使用 GAC

更多问题可以在 GitHub Issues 中搜索或提问。

---

<a id="use-cases"></a>
## 十、使用场景

本节用非常简短的方式说明几个典型使用场景。

### 10.1 个人项目

- 快速记录日常开发改动  
- 通过 AI 辅助生成更可读的提交说明  
- 长期看 commit history 更容易回顾自己的决策

### 10.2 团队协作

- 配置统一的 `LANGUAGE` 和 `COMMIT_FORMAT`，保证仓库提交风格一致  
- 在 Code Review 和 release notes 生成时更容易依赖 commit 信息  
- 结合 CI 工具（如 commitlint）可以进一步规范提交格式

### 10.3 内部/私有代码库

- 使用企业内部的 OpenAI 兼容服务或本地模型  
- 避免代码片段离开内网  
- 在合规前提下获得自动生成提交信息的便利

---

<a id="summary"></a>
## 总结

GAC 的核心功能是：

- 从 Git 暂存区收集改动信息  
- 调用配置好的 AI 服务生成提交信息  
- 通过简单的交互流程让你确认、编辑或重新生成

建议配合以下文档一起查看：

- `README.md`：项目总览与安装简介  
- `QUICKSTART.md`：几分钟内完成安装和首次使用  
- `AI_CONFIGURATION.md`：AI 服务与模型配置细节  
- `SHELL_FUNCTIONS.md`：常用 Shell 快捷函数  
- `CONTRIBUTING.md`：贡献指南

如果在使用中遇到问题或有改进建议，欢迎在 GitHub 上提交 issue 或参与讨论。
