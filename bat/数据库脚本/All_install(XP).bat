@echo off
cd /d %~dp0
::color 2f
echo ************************************************************
echo **                                                        **
echo **               SmartAIBank  Install                    **
echo **                                                        **
echo **            http://dcfs.digitalchina.com                **
echo **                                                        **
echo ************************************************************
set DB_PATH=%CD%
echo current path is %DB_PATH%
echo �������������ƽ̨��װ�����ݿ��IP�Ͷ˿�(127.0.0.1:1521)��
set /p HOST=
echo �������������ƽ̨��װ�����ݿ�SID��
set /p ORACLE_SID=
echo ������ָ�������ݿ��û�����
set /p DB_USER=

>"%temp%\GetPwd.vbs" echo WScript.Echo CreateObject("ScriptPW.PassWord").GetPassWord()
set DB_PWD=
set /p =���������ݿ��û�[%DB_USER%]������:<nul
for /f %%i in ('cscript //nologo "%temp%\GetPwd.vbs"') do set DB_PWD=%%i
del "%temp%\GetPwd.vbs"


echo ������ϲ��������⣬��Ctrl+C��ֹ�������������⣬�밴���������
pause

echo ************************************************************
echo ��װ���ݿ�... ...
sqlplus   %DB_USER%/%DB_PWD%@%HOST%/%ORACLE_SID%  @./install.sql  %DB_USER% >"%DB_PATH%\all.log"
echo ************************************************************
set /p =��װ��ϣ������뵽��%DB_PATH%��Ŀ¼�²鿴��־
exit

