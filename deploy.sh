#!/usr/bin/env bash
# ============================================================
#  StereoGS Project Page 一键部署到 GitHub Pages
#  Usage:
#     1. 在 GitHub 创建一个空仓库（不要初始化任何文件）
#     2. 第一次使用：在 https://github.com/settings/tokens 创建 PAT (classic)，勾选 'repo' 权限
#     3. 第一次使用：export GITHUB_TOKEN=<your_pat>
#     4. ./deploy.sh <github_user> [repo_name]
# ============================================================
set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- 参数检查 ---
if [ $# -lt 1 ]; then
  echo -e "${RED}❌ 用法: $0 <github用户名> [仓库名]${NC}"
  echo -e "${YELLOW}   例如: $0 eric-yuan stereogs${NC}"
  exit 1
fi

GH_USER="$1"
REPO_NAME="${2:-StereoGS_project_page}"
REMOTE_URL="https://github.com/${GH_USER}/${REPO_NAME}.git"
PAGES_URL="https://${GH_USER}.github.io/${REPO_NAME}/"

cd "$(dirname "$0")"

echo -e "${BLUE}📦 仓库: ${REMOTE_URL}${NC}"
echo -e "${BLUE}🌐 部署后地址: ${PAGES_URL}${NC}"
echo ""

# --- 检查 token ---
if [ -z "$GITHUB_TOKEN" ]; then
  echo -e "${YELLOW}⚠️  未设置 GITHUB_TOKEN 环境变量${NC}"
  echo -e "请按以下步骤获取 Personal Access Token (PAT):"
  echo -e "  1. 访问 ${BLUE}https://github.com/settings/tokens/new${NC}"
  echo -e "  2. Note 填 ${YELLOW}stereogs-deploy${NC}"
  echo -e "  3. Expiration 选 ${YELLOW}No expiration${NC} 或 90 天"
  echo -e "  4. 勾选 ${YELLOW}repo${NC} 权限"
  echo -e "  5. 点击 Generate token，复制 token"
  echo -e "  6. 在本终端执行: ${YELLOW}export GITHUB_TOKEN=ghp_xxxxxxxx${NC}"
  echo ""
  echo -e "或者: 直接使用 SSH 推送（无需 token）"
  echo -e "  把本脚本里的 ${YELLOW}REMOTE_URL${NC} 改为 ${BLUE}git@github.com:${GH_USER}/${REPO_NAME}.git${NC}"
  exit 1
fi

# --- 检查远程仓库是否存在 ---
echo -e "${BLUE}🔍 检查远程仓库...${NC}"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "https://api.github.com/repos/${GH_USER}/${REPO_NAME}")

if [ "$HTTP_CODE" = "404" ]; then
  echo -e "${YELLOW}📝 仓库不存在，自动创建...${NC}"
  CREATE_RESP=$(curl -s -X POST \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/user/repos" \
    -d "{\"name\":\"${REPO_NAME}\",\"description\":\"StereoGS: Sparse-View 3D Gaussian Splatting via Stereo Priors (ECCV 2026)\",\"private\":false,\"auto_init\":false}")
  if echo "$CREATE_RESP" | grep -q '"id"'; then
    echo -e "${GREEN}✅ 仓库创建成功: https://github.com/${GH_USER}/${REPO_NAME}${NC}"
  else
    echo -e "${RED}❌ 创建仓库失败:${NC}"
    echo "$CREATE_RESP"
    exit 1
  fi
elif [ "$HTTP_CODE" = "200" ]; then
  echo -e "${GREEN}✅ 仓库已存在${NC}"
else
  echo -e "${RED}❌ 检查仓库失败 (HTTP $HTTP_CODE)，请检查 GITHUB_TOKEN 是否有效${NC}"
  exit 1
fi

# --- 设置 remote 并推送 ---
echo -e "${BLUE}🔗 设置 remote...${NC}"
AUTH_URL="https://${GITHUB_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$AUTH_URL"
else
  git remote add origin "$AUTH_URL"
fi

echo -e "${BLUE}🚀 推送到 main...${NC}"
git branch -M main
git push -u origin main --force 2>&1 | tail -5

echo ""
echo -e "${GREEN}✅ 代码推送完成！${NC}"
echo ""
echo -e "${YELLOW}⏳ 接下来手动开启 GitHub Pages（仅需一次）：${NC}"
echo -e "  1. 访问 ${BLUE}https://github.com/${GH_USER}/${REPO_NAME}/settings/pages${NC}"
echo -e "  2. ${YELLOW}Source${NC} 选择 ${YELLOW}GitHub Actions${NC}"
echo -e "  3. 等 1-2 分钟后访问: ${BLUE}${PAGES_URL}${NC}"
echo ""
