<div align="center">
  <h1>🤖 Wechat AI Message Steward / 微信 AI 消息管家</h1>
  <p>A "Physical-Level" Zero Ban Risk WeChat Assistant / 一个“物理级”零封号风险的私人微信管家</p>

  <p>
    <a href="https://nodejs.org/"><img src="https://img.shields.io/badge/Node.js-%3E%3D18-green.svg" alt="Node.js"></a>
    <a href="https://wechaty.js.org/"><img src="https://img.shields.io/badge/Wechaty-Web_Protocol-blue.svg" alt="Wechaty"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License"></a>
  </p>
</div>

<br>

[English Version](#english-version) | [中文版](#中文版)

---

## English Version

**Are you overwhelmed by the sheer volume of WeChat messages, often missing critical tasks buried in chats? Do you desire a safe, *zero ban risk* WeChat message manager?** 

This project is exactly what you need! Running on any Linux system, it utilizes the Web protocol (`wechat4u`) without hooking the official WeChat client memory. It achieves seamless handover with the official Windows client through an elegant "Physical QR Code Handover" process.

### 🌟 Core Features
1. **Zero Ban Risk**: Purely simulates browser behavior and never touches the official client memory.
2. **Elegant Physical Handover**:
   - Work seamlessly on your Windows official WeChat client when you are at your desk.
   - When leaving, simply double-click the generated shortcut on your Windows desktop. The Linux server will instantly expose a login QR code.
   - Scan to login. The server takes over instantly, and your PC WeChat logs out automatically due to protocol exclusivity.
3. **Powerful AI Brain (MiniMax)**: Uses LLM to filter out idle chats and precisely extract structured "To-Do tasks" from "Whitelist Chat Rooms".
4. **Targeted Non-Intrusive Pushing**: Extracted to-do items are pushed to a dedicated "Summary Group" in a humanized butler tone. *(Tip: Use WeChat's "Face-to-Face Group" feature to create a single-member group just for yourself.)*
5. **Industrial-Grade Stability**: Powered by PM2 with a "Zero-Tolerance Suicide Mechanism" at the Node.js top level. 

### ☁️ Deployment Options
Compatible with **ANY Linux system**:
- **Lightweight Hosting (Cloud Server)**: Deploy on Ubuntu/CentOS/Debian cloud servers for 24/7 continuous operation without worrying about power or hardware. *(Note: Ensure port 3000 is not exposed to the public internet. Use SSH tunneling instead.)*
- **Privacy First (Local/Raspberry Pi)**: Deploy on a private Raspberry Pi or local Linux host for absolute data security. Highly recommended to connect it to your mobile hotspot for uninterrupted networking.

### 🛠️ Quick Deployment (1-Click)
**1. Linux (Core Service)**
- Clone this repository. Rename `.env.example` to `.env` and fill in your configs.
- Run `bash install.sh` to auto-install dependencies and setup the PM2 daemon.

**2. Windows (Handover Controller)**
- Edit `handover.py` and replace `YOUR_RASPBERRY_PI_IP_HERE` with your Linux host's actual IP.
- Double click `install.bat` to install Python dependencies and generate the desktop shortcut.

*(Please refer to the Chinese section below for detailed manual deployment and Hardcore Troubleshooting guide).*

---

## 中文版

**你是否感觉微信消息太多处理不过来，消息刷屏时常常漏掉重要任务？你是否渴望拥有一个安全、*零封号风险*的私人微信消息管家？**

本项目正是为您量身打造的终极解决方案！它完美兼容任何 Linux 系统，基于 Web 协议（wechat4u），绝不 Hook 官方客户端内存。通过优雅的“物理扫码交接”，实现与 Windows 官方客户端的无缝接力。

### 🌟 核心特性详细介绍
1. **绝对的账号安全 (零封号风险)**：抛弃高危的内存注入外挂，纯净模拟网页版浏览器行为，从物理和协议层面保证主账号的安全。
2. **优雅的“主备物理交接”闭环**：
   - **电脑前办公时**：使用 Windows 官方微信客户端，享受最完美的无延迟聊天体验。
   - **离开电脑时**：双击 Windows 桌面生成的快捷方式，触发 Linux 端瞬间暴露最新的高分辨率登录二维码。
   - **扫码接管**：拿起手机扫码，由于微信协议的互斥机制，PC 端自动下线，管家瞬间接管。
3. **强大的 AI 提炼大脑 (MiniMax)**：利用大模型强大的上下文理解能力，自动过滤闲聊，精准提取包含任务、时间、计划的“待办事项”。
4. **不打扰的定向防社死推送**：提取出的待办事项由 AI 转化为拟人化口吻，精准推送到您指定的“专属汇报群聊”中。
   > 💡 **建群小贴士**：专属汇报群聊怎么建？建议使用微信的**“面对面建群”**功能，输入四位数字即可创建一个只有您自己的群聊，专享私人 AI 汇报。
5. **工业级不死之身**：基于 PM2 守护进程，在 Node.js 顶层加入严格异常捕获。遇到网络波动直接强行自杀，交由系统级 PM2 瞬间拉起。

### ☁️ 部署场景选择
完美兼容任何 Linux 系统，您可以根据需求自由选择：
- ☁️ **轻量托管 (云服务器部署)**：部署在各大云厂商的 Linux 服务器上，实现 24 小时全天候无忧在线托管。
  *(⚠️ 注意：请勿在公网直接开放 3000 端口，建议通过 SSH 隧道或内网穿透映射到本地电脑。)*
- 🔒 **隐私至上 (树莓派/本地主机部署)**：部署在私人的树莓派或其他本地 Linux 主机上，确保数据绝对留在本地。强烈建议**连上手机热点**运行，以保证网络随身且极度稳定。

### 🛠️ 一键部署指南 (推荐)

**第一端：Linux 端 (核心服务)**
1. 将本项目 clone 或传输至您的 Linux 主机。
2. 将 `.env.example` 复制并重命名为 `.env`，填入您的 API Key 和群名配置。
3. 在终端执行 `bash install.sh`。脚本将自动安装 Node.js、Chromium 内核、PM2 守护进程，并配置开机自启。

**第二端：Windows 端 (物理交接控制台)**
1. 打开 `handover.py`，将 `YOUR_RASPBERRY_PI_IP_HERE` 占位符修改为您 Linux 主机的实际 IP 地址。
2. 双击运行 `install.bat`。脚本会自动安装所需的 Python 依赖，并在您的桌面上生成一个优雅的 **【AI管家】一键交接** 快捷方式。
3. 下班时，只需双击桌面快捷方式即可弹出二维码完成交接！

---

### ⚙️ 手动部署路径 (为硬核极客准备)

如果您的一键脚本执行失败，或者您想了解底层逻辑，请按以下步骤手动部署：

1. **环境准备 (Debian/Ubuntu/Raspberry Pi OS)**:
   ```bash
   sudo apt update
   sudo apt install -y nodejs npm chromium chromium-driver
   sudo npm install -g pm2
   ```
2. **安装 Node 依赖**:
   ```bash
   npm install --registry=https://registry.npmmirror.com
   ```
3. **环境变量配置**:
   修改 `.env` 文件，并在 `index.js` 中确认 `executablePath: '/usr/bin/chromium'` 的路径与您系统的 Chromium 路径一致（可通过 `which chromium` 查询）。
4. **启动与守护**:
   ```bash
   pm2 start index.js --name "wechat-bot"
   pm2 save
   pm2 startup
   ```

---

### 🪲 踩坑与排错指南 (Troubleshooting)

在构建这个架构的过程中，我们踩过了无数深坑。如果您在部署中遇到问题，请对照以下指南自救：

#### 🔴 坑 1: 启动报错 `Could not find expected browser (chrome) locally`
*   **症状**：PM2 日志疯狂报错，Wechaty 无法启动。
*   **原因**：通常发生在 **ARM 架构（如树莓派）**上。`npm install` 默认无法下载 ARM 版的 Chrome 内核。
*   **解法**：必须通过 `apt install chromium` 在系统层安装浏览器，然后在 `index.js` 的 `puppetOptions` 中手动指定 `executablePath: '/usr/bin/chromium'`。

#### 🔴 坑 2: 明明改了代码，依然报找不到 Chrome (幽灵依赖冲突)
*   **症状**：`package.json` 和代码都改成了 `wechaty-puppet-wechat4u`，但底层依然去加载旧的 `wechaty-puppet-wechat` 并报错。
*   **原因**：Wechaty 的底层逻辑会自动扫描 `node_modules`，如果有多个 puppet 协议包残留，它会加载错误的包。
*   **解法**：执行物理超度 `npm uninstall wechaty-puppet-wechat`，确保 `node_modules` 里只有 `wechat4u` 协议。

#### 🔴 坑 3: Windows 脚本无限卡在 `等待树莓派启动中...`
*   **症状**：双击 `handover.py` 后，迟迟弹不出二维码。
*   **原因 A (PM2 没保存)**：Node.js 收到 `/refresh` 接口的自杀指令后退出了，但您之前没有执行 `pm2 save` 和 `pm2 startup`，导致 PM2 守护进程忘了把它拉起来。
*   **原因 B (Session 缓存秒登)**：Wechaty 在本地生成了 `.wechaty.memory` 缓存文件。重启后它发现 Cookie 没过期，直接**免扫码自动登录**了！导致根本没有生成二维码。
*   **解法**：检查终端是否已经自动登录。如果是，这是正常现象，说明无需扫码交接已完成。

#### 🔴 坑 4: AI 提示 `未找到目标汇总群`
*   **症状**：日志显示提取到了待办，但报错找不到您指定的群（如“水上的微信消息管家”）。
*   **原因**：Web 协议微信刚登录时，不会同步您所有的群聊，只会同步**最近活跃的群**和**保存到通讯录的群**。
*   **解法**：请务必在手机微信中，将目标汇总群和需要监听的白名单群，设置为 **“保存到通讯录”** 或 **“置顶聊天”**。

#### � 坑 5: 日志频繁出现 `Client network socket disconnected before secure TLS connection`
*   **症状**：日志中有黄色的 `WARN`，或者直接触发了进程重启。
*   **原因**：如果您使用手机热点或网络环境不佳，在请求大模型 API 时发生了极短暂的网络波动（TLS 握手超时）。
*   **解法**：本项目已在 `axios` 请求层加入了 Error 捕获拦截，它会优雅地返回空字符并忽略该次请求，**不会再导致整个系统崩溃重启**。如果是底层 `wechat4u` 报的 WARN，可安全忽略。

---

### �🚀 未来规划 (Roadmap)
- 尝试开发 Windows 版本和 iOS 版本的原生管家。
- 探索接入微信平板端 (iPad) 或手表端 (Apple Watch) 协议，实现多端同时在线监听，**彻底省去“主备物理设备扫码交接”这一环**，敬请期待！