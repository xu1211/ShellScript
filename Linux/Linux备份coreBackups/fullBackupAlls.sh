#!/bin/bash

#@@��ǰĿ¼
workPath=/home/qhdshare/coreBackups
cd $workPath
if [ $? -eq 0 ]
then
	./fullBackupApps.sh
	./fullBackupServ.sh
else
	echo "$workPath�����ڣ����飡"
	exit 0
fi
