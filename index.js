import { WechatyBuilder } from 'wechaty';
import qrcodeTerminal from 'qrcode-terminal';
import axios from 'axios';
import express from 'express';
import dotenv from 'dotenv';

// 加载 .env 环境变量
dotenv.config();

// ================= 配置区 =================
// 从环境变量读取配置，如果没配置则使用默认值或报错
const MINIMAX_API_KEY = process.env.MINIMAX_API_KEY;
if (!MINIMAX_API_KEY) {
    console.error("【致命错误】未在 .env 文件中配置 MINIMAX_API_KEY！程序退出。");
    process.exit(1);
}

const MINIMAX_API_URL = process.env.MINIMAX_API_URL || "https://api.minimax.chat/v1/chat/completions";
const MODEL_NAME = process.env.MODEL_NAME || "abab6.5s-chat";

// 从环境变量读取白名单群，使用英文逗号分隔
const whitelistStr = process.env.WHITELIST_ROOMS || "APP开发分类梳理";
const WHITELIST_ROOMS = whitelistStr.split(',').map(room => room.trim());

const TARGET_ROOM_NAME = process.env.TARGET_ROOM_NAME || "水上的微信消息管家";
const EXPRESS_PORT = process.env.EXPRESS_PORT || 3000;
// ==========================================

// --- Express 服务器 (用于物理交接闭环) ---
const app = express();
let currentQrcode = null;
let currentStatus = 'init';
let currentUser = '';

app.get('/refresh', (req, res) => {
    res.json({ message: 'restarting' });
    setTimeout(() => {
        console.log('[Express] 收到刷新指令，主动自杀以便获取新鲜二维码...');
        process.exit(0);
    }, 500);
});

app.get('/qrcode', (req, res) => {
    if (currentQrcode) {
        res.json({ 
            code: 200, 
            url: `https://api.qrserver.com/v1/create-qr-code/?size=800x800&margin=20&data=${encodeURIComponent(currentQrcode)}` 
        });
    } else {
        res.json({ code: 400, message: '二维码尚未生成或已登录' });
    }
});

app.get('/status', (req, res) => {
    if (currentStatus === 'login') {
        res.json({ status: 'logged_in', user: currentUser });
    } else {
        res.json({ status: currentStatus });
    }
});

app.listen(EXPRESS_PORT, '0.0.0.0', () => {
    console.log(`[Express] 接口服务已启动，监听端口: ${EXPRESS_PORT}`);
});

// --- AI 处理核心 ---
async function extractTodoWithMinimax(messageText) {
    const headers = {
        "Authorization": `Bearer ${MINIMAX_API_KEY}`,
        "Content-Type": "application/json"
    };

    const systemPrompt = "你是一个高效的私人助理，专门提取结构化待办事项。如果包含明确的任务、时间或计划，请提取并以一段拟人化的管家口吻输出（如：'主人，帮您记录了一项新任务：...'）。如果是闲聊，请严格仅输出空的 JSON: {}。切勿输出其他解释性文字。";
    
    const payload = {
        model: MODEL_NAME,
        messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: `消息内容：${messageText}` }
        ]
    };

    try {
        const response = await axios.post(MINIMAX_API_URL, payload, { headers, timeout: 30000 });
        const result = response.data;
        
        if (result.choices && result.choices.length > 0) {
            return result.choices[0].message.content.trim();
        }
        return `【模型返回异常】: ${JSON.stringify(result)}`;
    } catch (error) {
        console.error('API请求失败:', error.message);
        return '{}';
    }
}

// --- 初始化 Wechaty 机器人 ---
const bot = WechatyBuilder.build({
    name: 'wechat-ai-bot',
    puppet: 'wechaty-puppet-wechat4u', // 使用更稳定的 wechat4u 协议
    puppetOptions: {
        head: false,
        executablePath: '/usr/bin/chromium' // 指定树莓派原生的 Chromium 路径
    }
});

bot.on('scan', (qrcode, status) => {
    currentStatus = 'scan';
    currentQrcode = qrcode;
    console.log(`\n[Scan] 状态: ${status}`);
    qrcodeTerminal.generate(qrcode, { small: true });
});

bot.on('login', user => {
    currentStatus = 'login';
    currentUser = user.name();
    currentQrcode = null;
    console.log(`\n[Login] 微信登录成功: ${user.name()}`);
});

bot.on('logout', user => {
    currentStatus = 'logout';
    console.log(`\n[Logout] 微信已登出: ${user.name()}`);
});

bot.on('message', async msg => {
    if (msg.self()) return; // 防死循环

    const room = msg.room();
    if (room) {
        const topic = await room.topic();
        
        if (!WHITELIST_ROOMS.includes(topic)) return;

        const text = msg.text();
        const contact = msg.talker();
        console.log(`\n[+] 收到群 [${topic}] 中 ${contact.name()} 的消息: ${text}`);
        
        const todoResult = await extractTodoWithMinimax(text);
        
        if (todoResult !== "{}") {
            console.log(`[-] 提取到待办，准备转发至 [${TARGET_ROOM_NAME}]...`);
            // 找到汇总群并发送
            const targetRoom = await bot.Room.find({ topic: TARGET_ROOM_NAME });
            if (targetRoom) {
                await targetRoom.say(`来自 [${topic}] 的 ${contact.name()}:\n${todoResult}`);
                console.log(`[√] 已成功转发至汇总群！`);
            } else {
                console.log(`[x] 未找到目标汇总群: ${TARGET_ROOM_NAME}，请确认名称是否正确且该群已保存在通讯录中。`);
            }
        }
    }
});

// --- 终极异常防守 (零容忍无条件自杀机制) ---
bot.on('error', (error) => {
    console.error('\n[Fatal Error] 机器人底层抛出致命错误，即将触发自杀机制由 PM2 重启：', error);
    process.exit(1);
});

process.on('uncaughtException', (err) => {
    console.error('\n[Uncaught Exception] 捕获到未处理的异常，执行零容忍自杀：', err);
    process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('\n[Unhandled Rejection] 捕获到未处理的 Promise 拒绝，执行零容忍自杀：', reason);
    process.exit(1);
});

// 启动机器人
bot.start()
    .then(() => console.log('正在启动 Wechaty (wechat4u 协议)...'))
    .catch(e => {
        console.error('启动失败:', e);
        process.exit(1);
    });