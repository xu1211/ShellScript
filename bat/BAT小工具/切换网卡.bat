@echo off
mode con lines=30 cols=60
color 2f
:��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
:���ֵ�ǰĿ¼������
cd /d "%~dp0"
::control netconnections
:main
cls

echo.----------------------------------------------------------- 
echo.��ѡ��ʹ�ã�
echo.
echo. 1.����"��̫��"IP
echo.
echo. 2.����"��̫��"IP
echo.
echo. 3.����WIFI "play"
echo.
echo. 0.�˳�
echo.-----------------------------------------------------------
set /p choice=���������ֲ����س���ȷ��:
if %choice%==1 cls & goto release
if %choice%==2 cls & goto renew
if %choice%==3 cls & goto WiFi
if %choice%==0 cls & goto end
echo. & echo ������Ч�ַ��� & pause>nul & cls & goto main


:release
cls
color 2f
::ipconfig/release ��̫��
netsh interface set interface "��̫��" disabled
echo ���óɹ�,�밴���������
@Pause
goto main

:renew
cls
color 2f
::ipconfig/renew ��̫��
netsh interface set interface "��̫��" enabled
ipconfig /flushdns
echo ���óɹ�,�밴���������
@Pause
goto main

:WiFi
cls
color 2f
netsh wlan connect name="play"
ipconfig /flushdns
echo ����WIFI
@Pause
goto main

:end
