
:: ��������del.bat
:: ע���: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
::         �½��ַ���ֵ-->c:\del.bat

Echo off
Echo ֹͣ��ӡ����
net stop "print spooler"

Echo  
Echo ɾ���ļ�
del /q %windir%\system32\spool\PRINTERS\*.*

Echo  
Echo ������ӡ����
net start "print spooler"

::�ӳ�
::choice /t 15 /d y /n >null
::ping -n 15 -w 500 0.0.0.1 >null
ping -n 15 127.0.0.1 >null

Echo ������������ӡ���ʹ��桻����
control printers


Echo ���
:: pause