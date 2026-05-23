@echo off
chcp 65001 >nul
echo ==============================================
echo     微信 AI 管家 - Windows 端一键部署脚本
echo ==============================================

echo.
echo [1/3] 正在检查 Python 环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 【错误】未检测到 Python！请先安装 Python 3.x 并将其添加到环境变量 PATH 中。
    pause
    exit /b
)
echo Python 环境正常。

echo.
echo [2/3] 正在安装交接脚本必需的依赖库...
pip install requests pillow -i https://pypi.tuna.tsinghua.edu.cn/simple
if %errorlevel% neq 0 (
    echo 【警告】依赖安装可能存在异常，请检查网络或稍后手动安装。
)

echo.
echo [3/3] 正在为您生成桌面快捷方式...
set "VBS_SCRIPT=%temp%\CreateShortcut.vbs"
set "SHORTCUT_PATH=%USERPROFILE%\Desktop\【AI管家】一键交接.lnk"
set "TARGET_PATH=%~dp0handover.py"
set "WORKING_DIR=%~dp0"

echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = "%SHORTCUT_PATH%" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "python.exe" >> "%VBS_SCRIPT%"
echo oLink.Arguments = """%TARGET_PATH%""" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%WORKING_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "双击执行微信物理交接" >> "%VBS_SCRIPT%"
:: 找一个稍微酷一点的系统图标
echo oLink.IconLocation = "%SystemRoot%\System32\shell32.dll, 174" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript /nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%"

echo.
echo ==============================================
echo 🎉 部署完成！
echo.
echo 您的桌面上已生成名为【AI管家】一键交接 的快捷方式。
echo 以后下班前，只需双击它，即可优雅地完成物理扫码交接！
echo ==============================================
pause
