@echo off
for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (set IP=%%a)
echo ��ľ�����IP�ǣ�
echo %IP%
echo.

@for /f "tokens=2 delims=:" %%f in ('@ipconfig /all^|findstr "..-..-..-..-..-.."') do @(echo ����MAC��ַ�ǣ�
echo %%f &pause>nul&goto:eof)


pause


