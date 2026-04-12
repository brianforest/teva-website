#!/bin/bash
# TEVA Website Sync Script
# Syncs local changes to GitHub with confirmation

set -e

cd "$(dirname "$0")"

echo "=============================="
echo "  TEVA 官網同步工具"
echo "=============================="
echo ""

# Show status
echo "📋 變更狀態："
git status --short
echo ""

# Check if there are changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✅ 沒有需要同步的變更。"
    exit 0
fi

# Show diff summary
echo "📊 變更摘要："
git diff --stat
echo ""

# Count changes
MODIFIED=$(git diff --name-only | wc -l | tr -d ' ')
UNTRACKED=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')
echo "修改: ${MODIFIED} 個檔案 | 新增: ${UNTRACKED} 個檔案"
echo ""

# Ask for confirmation
read -p "🔄 確定要同步到 GitHub？(y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消同步。"
    exit 0
fi

# Get commit message
echo ""
read -p "💬 輸入 commit 訊息（直接 Enter 使用預設）: " MSG
if [ -z "$MSG" ]; then
    MSG="Update: $(date '+%Y-%m-%d %H:%M')"
fi

# Stage, commit, push
git add -A
git commit -m "$MSG"
git push origin main

echo ""
echo "✅ 同步完成！"
echo "🌐 網站將在幾分鐘後更新。"
