@echo off

color 2F
title ������ͨ�Լ��
echo ���IP��ַ�ǣ�
for /f "tokens=4" %%p in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (echo     %%p)
echo.
echo ���MAC��ַ�ǣ�
@for /f "delims= " %%m in ('getmac^|findstr "..-..-..-..-..-.."') do (echo     %%m)
echo.

ipconfig/all

echo.
echo ���ڼ������״̬172.16.33.192�������ĵȴ�...
echo.
echo ---------------------------------------------------------

::�������״̬
ping -n 2 172.16.33.192 > %TEMP%\1.ping 
::���ݷ���ֵ���
findstr "TTL" %TEMP%\1.ping > nul
if %errorlevel%==0 (echo     �� ��������) else (echo     �� ���粻ͨ)         

::ɾ�������ļ�
if exist %TEMP%\*.ping del %TEMP%\*.ping
echo ---------------------------------------------------------

echo.
echo.
echo.
pause
