@echo off
mode con cols=14 lines=1
color 2f
::��ȡ����ԱȨ��
::%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
%1(start /min cmd.exe /c %0 :&exit)
:���ֵ�ǰĿ¼������
cd /d "%~dp0"

echo %date% %time%  -------�豸����------- >> pin.log

:start
ping 172.16.33.192 -n 1
IF ERRORLEVEL 1 goto 1 
IF ERRORLEVEL 0 goto 0 

:res
echo %date% %time%  -------����Ӧ��------- >> pin.log
ping 172.16.33.192 -n 1
IF ERRORLEVEL 1 goto 1 
IF ERRORLEVEL 0 
	call agent.bat 
	goto 0 

:0 
  echo ͨ
  echo %date% %time%  ������ͨ >> pin.log
  choice /t 60 /d y /n >nul
goto start


:1 
  echo ��ͨ
  echo %date% %time%  �����жϣ� >> pin.log
  taskkill /F /IM node.exe
  taskkill /F /IM SmartAIBank.exe
  choice /t 60 /d n /n >nul
goto res