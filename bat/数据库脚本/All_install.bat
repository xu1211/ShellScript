@echo off
cd /d %~dp0
::color 2f
echo ************************************************************
echo **                                                        **
echo **               SmartAIBank  Install                    **
echo **                                                        **
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
echo ������%DB_USER%�����룺
  set "psCommand=powershell -Command "$pword = read-host -AsSecureString ; ^
      $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
          [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
  for /f "usebackq delims=" %%p in (`%psCommand%`) do set DB_PWD=%%p


echo ������ϲ��������⣬��Ctrl+C��ֹ�������������⣬�밴���������
pause

echo ************************************************************
echo ��װ���ݿ�... ...
sqlplus   %DB_USER%/%DB_PWD%@%HOST%/%ORACLE_SID%  @./install.sql  %DB_USER% >"%DB_PATH%\add.log"
echo ************************************************************
set /p =��װ��ϣ������뵽��%DB_PATH%��Ŀ¼�²鿴��־
exit

