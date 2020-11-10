
:: 开机运行del.bat
:: 注册表: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
::         新建字符串值-->c:\del.bat

Echo off
Echo 停止打印服务
net stop "print spooler"

Echo  
Echo 删除文件
del /q %windir%\system32\spool\PRINTERS\*.*

Echo  
Echo 启动打印服务
net start "print spooler"

::延迟
::choice /t 15 /d y /n >null
::ping -n 15 -w 500 0.0.0.1 >null
ping -n 15 127.0.0.1 >null

Echo 主动开启『打印机和传真』窗口
control printers


Echo 完成
:: pause