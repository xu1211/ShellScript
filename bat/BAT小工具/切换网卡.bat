@echo off
mode con lines=30 cols=60
color 2f
:获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
:保持当前目录下运行
cd /d "%~dp0"
::control netconnections
:main
cls

echo.----------------------------------------------------------- 
echo.请选择使用：
echo.
echo. 1.禁用"以太网"IP
echo.
echo. 2.启用"以太网"IP
echo.
echo. 3.连接WIFI "play"
echo.
echo. 0.退出
echo.-----------------------------------------------------------
set /p choice=请输入数字并按回车键确认:
if %choice%==1 cls & goto release
if %choice%==2 cls & goto renew
if %choice%==3 cls & goto WiFi
if %choice%==0 cls & goto end
echo. & echo 输入有效字符！ & pause>nul & cls & goto main


:release
cls
color 2f
::ipconfig/release 以太网
netsh interface set interface "以太网" disabled
echo 禁用成功,请按任意键返回
@Pause
goto main

:renew
cls
color 2f
::ipconfig/renew 以太网
netsh interface set interface "以太网" enabled
ipconfig /flushdns
echo 启用成功,请按任意键返回
@Pause
goto main

:WiFi
cls
color 2f
netsh wlan connect name="play"
ipconfig /flushdns
echo 连接WIFI
@Pause
goto main

:end
