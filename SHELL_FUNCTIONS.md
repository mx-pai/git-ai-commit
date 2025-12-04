# GAC Shell 快捷函数

实用的 Shell 别名和函数，提升 GAC 使用效率。

## 快速配置

### Bash / Zsh

将以下内容添加到 `~/.bashrc` 或 `~/.zshrc`：

```bash
# GAC Shell Functions
# 添加以下内容到你的 ~/.bashrc 或 ~/.zshrc

cat >> ~/.bashrc << 'EOF'

# ========== GAC 快捷函数 ==========

# 快速提交：添加所有更改并生成 commit message
# Usage: cmt
cmt() {
    echo "Staging all changes..."
    git add .
    
    echo "Generating commit message..."
    gac
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "Commit completed."
    else
        echo "Commit cancelled or failed."
    fi
    
    return $exit_code
}

# 提交并推送：添加所有更改、提交并推送到远程
# Usage: cmp [branch_name]
cmp() {
    local branch=${1:-$(git branch --show-current)}
    
    echo "Staging all changes..."
    git add .
    
    echo "Generating commit message..."
    gac
    
    local commit_exit_code=$?
    
    if [ $commit_exit_code -eq 0 ]; then
        echo ""
        echo "Pushing to remote..."
        git push origin "$branch"
        
        local push_exit_code=$?
        if [ $push_exit_code -eq 0 ]; then
            echo "Commit and push completed successfully."
            return 0
        else
            echo "Push failed."
            return $push_exit_code
        fi
    else
        echo "Commit failed, push cancelled."
        return $commit_exit_code
    fi
}

# 预览 commit message：生成但不提交
# Usage: gac-preview
gac-preview() {
    echo "Staging all changes..."
    git add .
    
    echo "Previewing commit message..."
    echo ""
    
    # 生成但不自动确认
    CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/gac.conf}" \
    gac 2>&1 | tee /tmp/gac_preview.log
    
    echo ""
    echo "Preview complete (message not committed)."
    echo "To commit, run: gac"
}

# 提交已暂存的更改（不自动 add）
# Usage: gac-staged
gac-staged() {
    # 检查是否有暂存的更改
    if git diff --cached --quiet; then
        echo "No staged changes found. Use 'git add' first."
        return 1
    fi
    
    echo "Generating commit message for staged changes..."
    gac
}

# 使用简单格式提交
# Usage: gac-simple
gac-simple() {
    echo "Staging all changes..."
    git add .
    
    echo "Generating simple commit message..."
    COMMIT_FORMAT=simple gac
}

# 使用英文提交
# Usage: gac-en
gac-en() {
    echo "Staging all changes..."
    git add .
    
    echo "Generating commit message in English..."
    LANGUAGE=en gac
}

# 使用中文提交
# Usage: gac-zh
gac-zh() {
    echo "Staging all changes..."
    git add .
    
    echo "Generating commit message in Chinese..."
    LANGUAGE=zh gac
}

# 交互式提交：选择提交模式
# Usage: gac-interactive
gac-interactive() {
    echo "GAC interactive mode"
    echo "========================"
    echo "1. 标准提交 (cmt)"
    echo "2. 提交并推送 (cmp)"
    echo "3. 预览模式 (gac-preview)"
    echo "4. 仅提交已暂存 (gac-staged)"
    echo "5. 简单格式 (gac-simple)"
    echo "6. 英文提交 (gac-en)"
    echo "7. 中文提交 (gac-zh)"
    echo "0. 取消"
    echo ""
    
    read -p "请选择操作 [0-7]: " choice
    
    case $choice in
        1) cmt ;;
        2) cmp ;;
        3) gac-preview ;;
        4) gac-staged ;;
        5) gac-simple ;;
        6) gac-en ;;
        7) gac-zh ;;
        *) echo "Cancelled." ;;
    esac
}

# 清理 GAC 相关临时文件
# Usage: gac-clean
gac-clean() {
    echo "Cleaning GAC temporary files..."
    rm -f /tmp/gac_*.json
    rm -f /tmp/gac_preview*.log
    rm -f ~/test_api.sh ~/test_ai.sh 2>/dev/null
    echo "Cleanup complete."
}

# 显示 GAC 快捷函数帮助
# Usage: gac-functions-help
gac-functions-help() {
    echo "GAC Shell functions quick reference"
    echo "======================================"
    echo ""
    printf "%-20s | %s\n" "Function" "Description"
    printf "%-20s | %s\n" "--------" "-----------"
    printf "%-20s | %s\n" "cmt" "添加所有并提交 (最常用)"
    printf "%-20s | %s\n" "cmp" "添加、提交并推送"
    printf "%-20s | %s\n" "gac-preview" "预览 commit message"
    printf "%-20s | %s\n" "gac-staged" "仅提交已暂存文件"
    printf "%-20s | %s\n" "gac-simple" "使用简单格式提交"
    printf "%-20s | %s\n" "gac-en" "英文提交"
    printf "%-20s | %s\n" "gac-zh" "中文提交"
    printf "%-20s | %s\n" "gac-interactive" "交互式选择模式"
    printf "%-20s | %s\n" "gac-clean" "清理临时文件"
    printf "%-20s | %s\n" "gac-functions-help" "显示此帮助"
    echo ""
    echo "Tip: add 'gac-functions-help' to your shell startup for quick reference."
}

# ========== Git 别名 ==========

# 可选：方便的 Git 别名（如果尚未配置）
# 使用方式：git c, git ac, git cmt
alias git-c='git add -A && gac'
alias git-ac='git add . && gac'
alias git-cmt='gac'

# ========== 初始化完成 ==========

echo "GAC shell functions loaded."
echo "Type 'gac-functions-help' to see available functions."

EOF

# 重新加载配置（如果这是通过脚本运行的）
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi
```

### Fish Shell

对于 Fish 用户，使用增强版的 cmt.fish：

```fish
# cmt.fish

function cmt --description "Stage all changes and commit with AI generated message"
    echo "Staging all changes..."
    git add .
    
    if test $status -ne 0
        echo "Failed to stage changes."
        return 1
    end
    
    echo "Generating commit message..."
    gac
end

function cmp --description "Stage, commit and push"
    set -l branch (git branch --show-current)
    
    echo "Staging all changes..."
    git add .
    
    if test $status -ne 0
        echo "Failed to stage changes."
        return 1
    end
    
    echo "Generating commit message..."
    gac
    
    if test $status -eq 0
        echo ""
        echo "Pushing to origin/$branch..."
        git push origin $branch
    else
        echo "Commit failed, push cancelled."
        return 1
    end
end

function gac-preview --description "Preview commit message without committing"
    echo "Staging all changes..."
    git add .
    
    echo "Previewing commit message..."
    echo ""
    
    gac 2>&1 | tee /tmp/gac_preview.log
    
    echo ""
    echo "Preview complete (message not committed)."
    echo "To commit, run: gac"
end

function gac-help --description "Show GAC fish functions help"
    echo "GAC Fish functions"
    echo "===================="
    echo ""
    printf "%-20s | %s\n" "Command" "Description"
    printf "%-20s | %s\n" "-------" "-----------"
    printf "%-20s | %s\n" "cmt" "添加所有并提交"
    printf "%-20s | %s\n" "cmp" "添加、提交并推送"
    printf "%-20s | %s\n" "gac-preview" "预览 commit message"
    printf "%-20s | %s\n" "gac-help" "显示此帮助"
end
```

### PowerShell (Windows/WSL)

```powershell
# GAC PowerShell functions
# 添加到 $PROFILE 文件

function cmt {
    Write-Host "Staging all changes..." -ForegroundColor Blue
    git add .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to stage changes." -ForegroundColor Red
        return
    }
    
    Write-Host "Generating commit message..." -ForegroundColor Blue
    gac
}

function cmp {
    $branch = git branch --show-current
    
    Write-Host "Staging all changes..." -ForegroundColor Blue
    git add .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to stage changes." -ForegroundColor Red
        return
    }
    
    Write-Host "Generating commit message..." -ForegroundColor Blue
    gac
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Pushing to origin/$branch..." -ForegroundColor Green
        git push origin $branch
    } else {
        Write-Host "Commit failed, push cancelled." -ForegroundColor Red
    }
}

function gac-preview {
    Write-Host "Staging all changes..." -ForegroundColor Blue
    git add .
    
    Write-Host "Previewing commit message..." -ForegroundColor Blue
    Write-Host ""
    
    gac 2>&1 | Tee-Object -FilePath $env:TEMP\gac_preview.log
    
    Write-Host ""
    Write-Host "Preview complete (message not committed)." -ForegroundColor Yellow
    Write-Host "To commit, run: gac"
}
```

## 使用技巧

### 最常用的快捷方式

```bash
# 最常用的命令
cmt    # 添加并提交 (90% 的情况)
cmp    # 提交并推送 (准备分享代码)

# 偶尔使用
gac-preview     # 不确定时先预览
gac-staged      # 只想提交部分文件
gac-simple      # 快速简单的提交
```

### 推荐工作流

```bash
# 1. 开发中频繁提交（使用 cmt）
cmt
# [y] 确认提交

# 2. 功能完成后推送（使用 cmp）
cmp feature/user-auth
# 自动生成 message + 推送到远程

# 3. 不确定时使用预览
gac-preview
# 查看 message 是否满意
# 然后手动运行 gac
```

### 性能优化

```bash
# 如果经常需要切换语言，在 ~/.bashrc 添加别名
alias gac-en="LANGUAGE=en gac"
alias gac-zh="LANGUAGE=zh gac"

# 如果想默认中文
# 在 ~/.config/gac.conf 中设置 LANGUAGE="zh"
```

## 帮助命令

```bash
# 查看所有快捷函数
gac-functions-help  # Bash/Zsh
gac-help            # Fish

# 快速参考
gac --help         # GAC 主帮助
make help          # Makefile 任务
```

## 相关文档

- [README.md](README.md) - GAC 主要文档
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - 详细使用指南
- [QUICKSTART.md](QUICKSTART.md) - 快速开始
- [CONTRIBUTING.md](CONTRIBUTING.md) - 贡献指南

---

提示：最常用的函数是 `cmt` (commit) 和 `cmp` (commit & push)，其他函数按需使用。
