@echo off

color 2F
title 网络连通性检测
echo 你的IP地址是：
for /f "tokens=4" %%p in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (echo     %%p)
echo.
echo 你的MAC地址是：
@for /f "delims= " %%m in ('getmac^|findstr "..-..-..-..-..-.."') do (echo     %%m)
echo.

ipconfig/all

echo.
echo 正在检测网络状态172.16.33.192，请耐心等待...
echo.
echo ---------------------------------------------------------

::检测网络状态
ping -n 2 172.16.33.192 > %TEMP%\1.ping 
::根据返回值输出
findstr "TTL" %TEMP%\1.ping > nul
if %errorlevel%==0 (echo     √ 网络正常) else (echo     × 网络不通)         

::删除缓存文件
if exist %TEMP%\*.ping del %TEMP%\*.ping
echo ---------------------------------------------------------

echo.
echo.
echo.
pause
