@echo off
mode con cols=14 lines=1
color 2f
:保持当前目录下最小化运行
%1(start /min cmd.exe /c %0 :&exit)
cd /d "%~dp0"

echo %date% %time%  -------设备开机------- >> pin.log

:start
ping 172.16.33.192 -n 1
IF ERRORLEVEL 1 goto 1 
IF ERRORLEVEL 0 goto 0 


:0 
  echo %date% %time%  网络连通 >> pin.log
  choice /t 300 /d y /n >nul
goto start


:1 
  echo %date% %time%  网络中断！ >> pin.log
  choice /t 300 /d n /n >nul
goto start