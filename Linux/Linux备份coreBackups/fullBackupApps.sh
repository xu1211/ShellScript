#!/bin/bash
####################################################################################################@@
#@@echo '******************************************************************************'
#@@echo '* 功能：应用全量备份脚本                                                      '
#@@echo '* 前提：                                                                      '
#@@echo '*        设置Linux scp 免密码登陆。	                                       '
#@@echo '* 版本：                                                                      '
#@@echo '*     1、2017-10-31：WangChunyun建立。                                        '
#@@echo '******************************************************************************'
####################################################################################################@@

#@@当前目录
workPath=/home/qhdshare/coreBackups
cd $workPath

#@@当前服务器名
HostName=`hostname`

#@@系统日期
backUpDate=`date "+%Y%m%d"`
#@@系统时间
backUpTime=`date "+%H%M%S"`
#@@系统时间戳
backUpDateTime=`date "+%Y%m%d_%H%M%S"`

#@@本地备份根目录
bakFileRoot=~/.cronBackup/fullBackup
#@@当日备份文件夹
bakFileDir=$bakFileRoot/$backUpDate
#@@当日临时文件文件夹
bakFileTmp=$bakFileRoot/$backUpDate/tmp

#@@应用备份配置
appsCfg=$workPath/configs/$HostName/apps.cfg
if [ ! -f $appsCfg ]
then
	echo "$appsCfg配置文件不存在！"
	exit 0
fi

#@@检查上次备份是否完成
serverLock=$workPath/configs/$HostName.lock
if [ ! -f $serverLock ]
then
	touch $serverLock
else
	echo "$HostName备份正在执行中，请稍后再试！"
	exit 0
fi

#@@创建日期备份文件夹
if [ ! -d $bakFileDir ]
then
	mkdir -p $bakFileDir
	mkdir -p $bakFileTmp
	chmod -R 777 $bakFileDir
else
	sleep 1
fi

scpUser=""
scpIp=""
scpPath=""

echo '******************************************************************************'
echo "Apps Backup Start ..."
#@@读取配置文件
cat $appsCfg |while read line;
do
	#@@eg:cbsd=/app/qhdprod/apps/cbsd
	#@@应用名称
	appName=`echo $line | awk -F "=" '{ print $1 }'`
	#@@应用绝对路径
	appPath=`echo $line | awk -F "=" '{ print $2 }'`
	#@@备份文件名称
	arcName=$HostName-apps-$appName-$backUpDateTime

	if [ "$appName" = "" ]
	then
		echo "请检查$appsCfg配置文件有效性！"
		continue
	fi
	if [ "$appPath" = "" ]
	then
		echo "请检查$appsCfg配置文件有效性！"
		continue
	fi
	
	#@@判断文件开头是否以#开头则跳过
	#@@echo "$appName" | grep -q "#"
	#@@if [ $? -eq 0 ]
	#@@then
	#@@	echo $appName
	#@@	continue
	#@@fi

	echo "Backup [$appName] Start, Path Value Is [$appPath] ..."

	#@@切换目录至应用文件夹
	cd $appPath
	#@@切换成功
	if [ $? -eq 0 ]
	then
		#@@新建当日备份
		echo "Create [$bakFileDir/$arcName.tar.gz] ..."
		tar -zcf $bakFileDir/$arcName.tar.gz $appPath
	fi
	echo "Backup [$appName] End ..."
	cd $workPath
done

cd $workPath

#@@备份昨日备份至备份服务器
if [ -d $bakFileRoot ]
then
	echo "Scp [$bakFileRoot] Begin..."
	############################################################@@
	##@@ read the config file
	##@@ config file directory is ./configs/scpFullBackup.cfg
	############################################################@@
	eval $(awk -F"=" '{
			      if ($1~/scpIp/) print "scpIp="$2; 
			      if ($1~/scpUser/) print "scpUser="$2;
			      if ($1~/scpPath/) print "scpPath="$2;
			  }' ./configs/scpFullBackup.cfg)

	scp -r $bakFileRoot $scpUser@$scpIp:$scpPath
	if [ $? -eq 0 ]
	then
		echo "Delete [$bakFileRoot] ..."
		rm -rf $bakFileRoot
	else
		echo "备份全量备份$bakFileRoot至远程备份服务器失败！"
	fi
	echo "Scp [$bakFileRoot] End..."
fi

#@@清理临时文件
echo "Clear Tmp File Begin ..."
cd $workPath
rm -f $serverLock
echo "Clear Tmp File End ..."

echo "Apps Backup End ..."
echo '******************************************************************************'
exit 0