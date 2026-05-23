import os
import time
import requests
import tkinter as tk
from urllib.request import urlopen
from PIL import Image, ImageTk
import io

# ================= 配置区 =================
# 请确保这是您树莓派的最新局域网 IP (部署前请修改)
RASPBERRY_PI_IP = "YOUR_RASPBERRY_PI_IP_HERE" 
API_URL = f"http://{RASPBERRY_PI_IP}:3000/qrcode"
# ==========================================

def trigger_refresh():
    print("[1/3] 正在通知树莓派生成最新二维码...")
    try:
        # 请求树莓派的刷新接口，超时设短一点，因为树莓派收到后会立刻自杀重启
        requests.get(f"http://{RASPBERRY_PI_IP}:3000/refresh", timeout=1)
    except Exception:
        # 肯定会超时或连接断开，因为树莓派已经自杀重启了，这是预期行为
        pass
    print("树莓派已收到指令，正在重启获取新鲜二维码...")
    time.sleep(3) # 给树莓派留出 PM2 重启的时间

def wait_for_qrcode():
    print(f"[2/3] 正在抓取最新二维码...")
    while True:
        try:
            response = requests.get(API_URL, timeout=3)
            data = response.json()
            if data.get("code") == 200:
                print("[√] 成功获取到热乎的二维码！")
                return data.get("url")
            else:
                print("树莓派正在生成二维码，请稍候...")
        except Exception as e:
            print(f"等待树莓派启动中...")
        time.sleep(2)

def show_qrcode(img_url):
    print("[3/3] 正在屏幕中央弹出二维码，请拿起手机准备扫码！")
    
    # 下载图片数据
    image_bytes = urlopen(img_url).read()
    data_stream = io.BytesPath(image_bytes) if hasattr(io, 'BytesPath') else io.BytesIO(image_bytes)
    pil_image = Image.open(data_stream)
    
    # 创建无边框置顶窗口
    root = tk.Tk()
    root.title("微信 AI 管家 - 交接仪式")
    root.attributes("-topmost", True) # 窗口置顶
    
    # 居中显示
    window_width = 480
    window_height = 520
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    x = int((screen_width / 2) - (window_width / 2))
    y = int((screen_height / 2) - (window_height / 2))
    root.geometry(f"{window_width}x{window_height}+{x}+{y}")
    
    # 调整图片大小并显示
    pil_image = pil_image.resize((400, 400), Image.Resampling.LANCZOS if hasattr(Image, 'Resampling') else Image.ANTIALIAS)
    tk_image = ImageTk.PhotoImage(pil_image)
    
    label = tk.Label(root, image=tk_image)
    label.pack(expand=True)
    
    # 添加提示文字
    text_label = tk.Label(root, text="请使用手机微信扫描上方二维码，完成主备交接\n(扫码成功后此窗口将自动关闭)", font=("微软雅黑", 12))
    text_label.pack(side="bottom", pady=10)
    
    # 定时器：轮询树莓派的登录状态
    def check_login_status():
        try:
            status_url = f"http://{RASPBERRY_PI_IP}:3000/status"
            res = requests.get(status_url, timeout=2)
            data = res.json()
            if data.get("status") == "logged_in":
                print("\n==============================================")
                print(f"🎉 树莓派接管成功！")
                print(f"✅ 登录账号: {data.get('user')}")
                print("📡 AI 监听进程已在后台稳稳运行，您可以放心关机了！")
                print("==============================================\n")
                root.destroy()  # 自动销毁窗口
                return
        except Exception:
            pass
        # 如果还没登录，1 秒后再查一次
        root.after(1000, check_login_status)

    # 启动定时轮询
    root.after(1000, check_login_status)
    
    root.mainloop()

if __name__ == "__main__":
    print("==============================================")
    print("      微信 AI 管家 - 关机前物理交接脚本       ")
    print("==============================================\n")
    
    trigger_refresh()
    qr_url = wait_for_qrcode()
    show_qrcode(qr_url)
