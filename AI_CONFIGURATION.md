# GAC AI 配置指南

本指南只关注一件事：GAC 需要哪些配置项，以及如何切换不同的 AI 服务或模型，不做具体服务商或模型的对比推荐。

## 1. OpenAI 兼容 API（推荐）

这是最通用的方式，支持所有兼容 OpenAI Chat Completions 接口的服务（通常是 `POST /v1/chat/completions`）。

### 最小配置

```bash
# 必需配置（最小配置）
AI_API_URL="https://api.example.com/v1/chat/completions"  # API 端点
AI_API_KEY="sk-your-api-key"                              # API 密钥

# 可选配置（GAC 会自动推断）
AI_MODEL="your-model-name"  # 模型名称，不设置则由服务端默认或在调用时指定
```

说明：

- 只要服务兼容 OpenAI Chat Completions 接口，就可以直接使用。
- 切换服务商时，一般只需要同时修改 `AI_API_URL`、`AI_API_KEY`（如果需要）和 `AI_MODEL`。
- 具体可用模型、价格和限额请以各服务商文档为准，这里只关心如何配置和切换。

### 示例：本地服务（例如 Ollama）

```bash
# 启动本地服务后，先拉取模型，例如：
#   ollama pull your-local-model-name

AI_API_URL="http://localhost:11434/v1/chat/completions"
AI_API_KEY="ollama"              # 任意非空值即可
AI_MODEL="your-local-model-name"
```

### 临时切换模型（仅当前命令生效）

```bash
AI_MODEL="your-other-model-name" gac
```

### 快速自测

```bash
# 假设配置已经写在 ~/.config/gac.conf
source ~/.config/gac.conf

curl "$AI_API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${AI_API_KEY}" \
  -d '{"model":"'"${AI_MODEL:-your-model-name}"'","messages":[{"role":"user","content":"test"}],"max_tokens":10}'
```

如果返回正常的 JSON 文本回复，GAC 一般就可以正常工作；更详细的排查见 `USAGE_GUIDE.md`。

## 2. Claude CLI（可选）

如果你已经在使用 Claude CLI，也可以让 GAC 直接调用它；否则更推荐使用 OpenAI 兼容 API。

### 配置模板

```bash
# ============================================================================
# AI Model Configuration - Claude CLI
# ============================================================================

# 启用 Claude CLI 模式
USE_CLAUDE_CLI=true

# 可选配置
ANTHROPIC_AUTH_TOKEN="sk-ant-xxx"        # Claude API 密钥
ANTHROPIC_BASE_URL="https://api.anthropic.com"  # 自定义端点（可选）
ANTHROPIC_MODEL="your-claude-model-name" # 指定模型（可选）
```

### 安装 Claude CLI

```bash
pip install claude-cli
claude --version
```

## 3. 环境变量一览

与 GAC 相关的主要环境变量如下。配置文件和环境变量的名字完全一致，环境变量优先级更高。

| 变量名               | 说明               | 是否必需     | 示例值                                           |
|----------------------|--------------------|--------------|--------------------------------------------------|
| `AI_API_URL`         | API 端点地址       | API 模式必需 | `https://api.example.com/v1/chat/completions`    |
| `AI_API_KEY`         | API 密钥           | API 模式必需 | `sk-your-api-key`                                |
| `AI_MODEL`           | 模型名称           | 可选         | `your-model-name`                                |
| `USE_CLAUDE_CLI`     | 启用 Claude CLI    | 可选         | `true`                                           |
| `ANTHROPIC_AUTH_TOKEN` | Claude API 密钥 | 可选         | `sk-ant-xxx`                                     |
| `LANGUAGE`           | 消息语言           | 可选         | `zh` / `en`                                      |
| `COMMIT_FORMAT`      | 消息格式           | 可选         | `conventional` / `simple`                        |
| `MAX_DIFF_LINES`     | Diff 行数限制     | 可选         | `500`                                            |
| `EDITOR`             | 编辑器             | 可选         | `vim` / `code --wait`                            |

### 示例：使用环境变量临时覆盖配置

```bash
# 配置文件中设置通用参数，命令行临时切换模型
AI_MODEL="your-model-name" gac
```

---

更多项目级配置、本地模型和别名示例，请参考 `USAGE_GUIDE.md` 的相关章节。

> 我自己日常使用的 API 服务：https://yunwu.ai/register?aff=Ndh5 （仅供参考，请按需选择）

