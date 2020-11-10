#!/bin/bash

#@@当前目录
workPath=/home/qhdshare/coreBackups

cd $workPath

if [ $? -eq 0 ]
then
	./patchBackupLogs.sh
	./patchBackupApps.sh
	./patchBackupServ.sh
else
	echo "$workPath不存在，请检查！"
	exit 0
fi