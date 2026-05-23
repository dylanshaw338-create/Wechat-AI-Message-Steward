FROM node:18-bullseye-slim

# 安装必要的依赖 (Puppeteer 运行 Chrome 所需)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils \
    chromium \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 核心：告诉 Puppeteer 不要去下载不支持 ARM64 的 Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 设置环境变量，跳过下载 Puppeteer 默认的 Chromium，使用系统中安装的或者让它自己下
ENV WECHATY_PUPPET_WECHAT_PUPPETEER_UOS=true
ENV WECHATY_PUPPET=wechaty-puppet-wechat

WORKDIR /app

# 拷贝 package.json 并安装 npm 依赖
COPY package.json ./
# 设置淘宝镜像加速 npm 安装
RUN npm config set registry https://registry.npmmirror.com/
RUN npm install

# 拷贝核心代码
COPY index.js ./

CMD ["npm", "start"]