# GAC 快速开始

5 分钟快速上手 GAC (Git AI Commit)。

## 快速安装与使用

### 1. 检查依赖（30秒）

```bash
# 检查是否已安装
git --version
curl --version
jq --version

# 如果有任何命令未找到，安装（Ubuntu/Debian）
sudo apt install -y git curl jq
```

### 2. 安装 GAC（1分钟）

```bash
cd ~/project/gac
./install.sh
```

### 3. 配置 API（2分钟）

GAC 通过兼容 OpenAI Chat Completions 接口的服务生成 commit message。配置示例：

```bash
# 打开配置文件
nano ~/.config/gac.conf

# 方式 1：云端服务（示例）
AI_API_URL="https://api.example.com/v1/chat/completions"
AI_API_KEY="sk-your-api-key"
AI_MODEL="your-model-name"
LANGUAGE="zh"

# 方式 2：本地 Ollama（示例）
#AI_API_URL="http://localhost:11434/v1/chat/completions"
#AI_API_KEY="ollama"
#AI_MODEL="your-local-model-name"
```

更完整的配置说明和环境变量介绍，见 `AI_CONFIGURATION.md`。

我自己日常使用的 API 服务：https://yunwu.ai/register?aff=Ndh5 （仅供参考，请按需选择）

**安装 Ollama（可选）：**

```bash
# 访问 https://ollama.ai 下载并安装
# 然后运行：
ollama pull your-local-model-name
ollama list
```

### 4. 开始使用（1分钟）

```bash
# 在任何 Git 项目中
git add .
gac

# AI 会生成 commit message，选择：
# [y] 使用   [e] 编辑   [r] 重新生成   [n] 取消
```

## 常见问题快速解答

### 问题 1: `gac: command not found`

```bash
# 添加到 PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 问题 2: API 没有响应

```bash
# 检查配置是否正确
source ~/.config/gac.conf
echo "URL: $AI_API_URL"
echo "Key: ${AI_API_KEY:0:10}..."

# 测试网络
curl -I "$AI_API_URL"
```

### 问题 3: 没有暂存的更改

```bash
# 先添加文件
git add .
gac
```

## 推荐的快捷函数

在 `~/.bashrc` 中添加：

```bash
# 快速提交
cmt() { git add . && gac; }

# 提交并推送
cmp() { git add . && gac && git push; }
```

然后运行：`source ~/.bashrc`

## 完整文档

- [详细使用指南](USAGE_GUIDE.md) - 完整教程和最佳实践
- [README.md](README.md) - 项目说明和详细配置

## 小贴士

1. **经常使用 `[e]` 编辑**：虽然 AI 生成很好，但根据上下文手动优化更好
2. **小步提交**：频繁的小提交比一次大提交效果更好
3. **保护 API key**：不要在代码仓库中提交配置文件
4. **选择合适的模型**：可以为日常提交设置一个响应更快、成本更低的默认模型，复杂改动时再临时切换到更强的模型

---

你已经掌握了 GAC 的基本使用，可以开始在日常提交中尝试使用它了。
