#!/usr/bin/env bash
# 推送脚本：填入你的仓库地址和 Token 后运行
# 用法: bash push.sh
set -e

# ===== 填这里 =====
REPO_URL="https://github.com/你的用户名/你的仓库名.git"   # 改成你的仓库地址
TOKEN="ghp_xxxxxxxxxxxxxxxx"                               # 改成你的 Personal Access Token
BRANCH="main"
# ==================

cd "$(dirname "$0")"

# 用 Token 拼出带认证的远程地址（不会明文写进 git config 历史）
AUTH_URL="https://${TOKEN}@${REPO_URL#https://}"

git remote remove origin 2>/dev/null || true
git remote add origin "$AUTH_URL"

git branch -M "$BRANCH"
git push -u origin "$BRANCH"

echo "✅ 推送完成"
