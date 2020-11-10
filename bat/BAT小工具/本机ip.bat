@echo off
for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (set IP=%%a)
echo 你的局域网IP是：
echo %IP%
echo.

@for /f "tokens=2 delims=:" %%f in ('@ipconfig /all^|findstr "..-..-..-..-..-.."') do @(echo 本机MAC地址是：
echo %%f &pause>nul&goto:eof)


pause


