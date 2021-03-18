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
echo 请输入网点管理平台安装的数据库的IP和端口(127.0.0.1:1521)：
set /p HOST=
echo 请输入网点管理平台安装的数据库SID：
set /p ORACLE_SID=
echo 请输入指定的数据库用户名：
set /p DB_USER=
echo 请输入%DB_USER%的密码：
  set "psCommand=powershell -Command "$pword = read-host -AsSecureString ; ^
      $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
          [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
  for /f "usebackq delims=" %%p in (`%psCommand%`) do set DB_PWD=%%p


echo 如果以上参数有问题，请Ctrl+C终止操作，若无问题，请按任意键继续
pause

echo ************************************************************
echo 安装数据库... ...
sqlplus   %DB_USER%/%DB_PWD%@%HOST%/%ORACLE_SID%  @./install.sql  %DB_USER% >"%DB_PATH%\add.log"
echo ************************************************************
set /p =安装完毕，详情请到“%DB_PATH%”目录下查看日志
exit

