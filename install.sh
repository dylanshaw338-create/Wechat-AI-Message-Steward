#!/bin/bash
set -e

echo "=============================================="
echo "    微信 AI 消息管家 - Linux 树莓派一键安装脚本   "
echo "=============================================="

# 1. 检查是否在项目目录内
if [ ! -f "package.json" ]; then
    echo "【错误】找不到 package.json！请确保你在 wechat-node-bot 目录下运行此脚本。"
    exit 1
fi

# 2. 检查 .env 配置文件
if [ ! -f ".env" ]; then
    echo "【警告】找不到 .env 配置文件！"
    echo "正在从 .env.example 复制默认配置..."
    cp .env.example .env
    echo "请按 Ctrl+C 退出，先使用 nano .env 填入你的 API Key，然后再重新运行此脚本！"
    exit 1
fi

echo -e "\n[1/5] 正在更新系统并安装 Chromium 浏览器内核..."
sudo apt-get update
sudo apt-get install -y chromium chromium-driver

echo -e "\n[2/5] 正在安装 Node.js 基础环境..."
if ! command -v npm &> /dev/null; then
    sudo apt-get install -y nodejs npm
else
    echo "Node.js 已安装，跳过。"
fi

echo -e "\n[3/5] 正在安装项目依赖 (使用淘宝镜像防超时)..."
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
npm install --registry=https://registry.npmmirror.com

echo -e "\n[4/5] 正在安装 PM2 守护进程..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
else
    echo "PM2 已安装，跳过。"
fi

echo -e "\n[5/5] 正在启动服务并配置开机自启..."
# 清理旧进程
pm2 delete wechat-bot 2>/dev/null || true
# 以错误日志级别启动，保持终端纯净
WECHATY_LOG=error pm2 start index.js --name "wechat-bot"
# 保存状态
pm2 save

echo "=============================================="
echo "🎉 恭喜！树莓派端部署完成！"
echo "守护进程已在后台运行。"
echo "请执行 'pm2 logs wechat-bot' 查看二维码进行首次登录！"
echo "=============================================="
