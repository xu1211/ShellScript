@echo off
mode con cols=14 lines=1
color 2f
::获取管理员权限
::%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
%1(start /min cmd.exe /c %0 :&exit)
:保持当前目录下运行
cd /d "%~dp0"

echo %date% %time%  -------设备开机------- >> pin.log

:start
ping 172.16.33.192 -n 1
IF ERRORLEVEL 1 goto 1 
IF ERRORLEVEL 0 goto 0 

:res
echo %date% %time%  -------重启应用------- >> pin.log
ping 172.16.33.192 -n 1
IF ERRORLEVEL 1 goto 1 
IF ERRORLEVEL 0 
	call agent.bat 
	goto 0 

:0 
  echo 通
  echo %date% %time%  网络连通 >> pin.log
  choice /t 60 /d y /n >nul
goto start


:1 
  echo 不通
  echo %date% %time%  网络中断！ >> pin.log
  taskkill /F /IM node.exe
  taskkill /F /IM SmartAIBank.exe
  choice /t 60 /d n /n >nul
goto res