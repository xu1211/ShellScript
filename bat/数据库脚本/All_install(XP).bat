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
echo 请输入网点管理平台安装的数据库的IP和端口(127.0.0.1:1521)：
set /p HOST=
echo 请输入网点管理平台安装的数据库SID：
set /p ORACLE_SID=
echo 请输入指定的数据库用户名：
set /p DB_USER=

>"%temp%\GetPwd.vbs" echo WScript.Echo CreateObject("ScriptPW.PassWord").GetPassWord()
set DB_PWD=
set /p =请输入数据库用户[%DB_USER%]的密码:<nul
for /f %%i in ('cscript //nologo "%temp%\GetPwd.vbs"') do set DB_PWD=%%i
del "%temp%\GetPwd.vbs"


echo 如果以上参数有问题，请Ctrl+C终止操作，若无问题，请按任意键继续
pause

echo ************************************************************
echo 安装数据库... ...
sqlplus   %DB_USER%/%DB_PWD%@%HOST%/%ORACLE_SID%  @./install.sql  %DB_USER% >"%DB_PATH%\all.log"
echo ************************************************************
set /p =安装完毕，详情请到“%DB_PATH%”目录下查看日志
exit

