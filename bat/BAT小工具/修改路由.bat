@echo off
mode con lines=30 cols=60
color 2f
:获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
:保持当前目录下运行
cd /d "%~dp0"

route -p add 0.0.0.0 mask 0.0.0.0  192.168.43.158
route -p add 172.16.0.0 mask 255.255.0.0 172.16.83.254

@Pause
