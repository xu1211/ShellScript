#!/bin/bash
####################################################################################################@@
#@@echo '******************************************************************************'
#@@echo '* 功能：应用文件备份脚本                                                      '
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
#@@上一日日期
lastBackUpDate=`date -d '1 days ago' "+%Y%m%d"`

#@@本地备份根目录
bakFileRoot=~/.cronBackup
#@@当日备份文件夹
bakFileDir=$bakFileRoot/$backUpDate
#@@当日临时文件文件夹
bakFileTmp=$bakFileRoot/$backUpDate/tmp
#@@昨日备份文件夹
lastBakFileDir=$bakFileRoot/$lastBackUpDate

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

#@@创建指定时间的文件以用于find -newer 命令
############################################
newerF1="$lastBackUpDate"0000
newerF2="$backUpDate"0000

newerN1=$HostName-$newerF1
newerN2=$HostName-$newerF2

touch -t $newerF1 $newerN1
touch -t $newerF2 $newerN2
############################################

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
	echo "$appName" | grep -q "#"
	if [ $? -eq 0 ]
	then
		echo $appName
		continue	
	fi

	echo "Backup [$appName] Start, Path Value Is [$appPath] ..."

	#@@切换目录至应用文件夹
	cd $appPath
	#@@切换成功
	if [ $? -eq 0 ]
	then
		#@@区间内应用文件变化量
		find $appPath -newer $workPath/$newerN1 ! -newer $workPath/$newerN2 ! -wholename '*.xdc*'  ! -wholename '*XmlDatas*' ! -wholename '*classes*' ! -wholename '*temp*' ! -wholename '*AdminServer*' ! -wholename '*qhdshare*' ! -wholename '*_TP_REPORT*' ! -wholename '*.ctl*' ! -wholename '*log*' ! -wholename '*.out*' ! -wholename '*.zip*' ! -wholename '*.DAT*' ! -wholename '*.tar.gz*' ! -wholename '*config.lok*' ! -wholename '*/hibernate/*' -type f > "$bakFileTmp/$arcName.tmp"

		#@@查找结果为空即没有变化
		if [ ! -s $bakFileTmp/$arcName.tmp ]
		then
			#@@删除昨日备份，以实现变化全量备份
			echo "Delete [$lastBakFileDir/$HostName-apps-$appName] ..."
			rm -f $lastBakFileDir/$HostName-apps-$appName-*
		fi
		#@@新建当日备份
		echo "Create [$bakFileDir/$arcName.tar.gz] ..."
		rm -f $bakFileDir/$HostName-apps-$appName-*
		tar -zcf $bakFileDir/$arcName.tar.gz $appPath
	fi
	echo "Backup [$appName] End ..."
	cd $workPath
done

cd $workPath

#@@备份昨日备份至备份服务器
#@@if [ -d $lastBakFileDir ]
#@@then
#@@	echo "Scp [$lastBakFileDir] Begin..."
#@@	############################################################@@
#@@	##@@ read the config file
#@@	##@@ config file directory is ./configs/scpPatchBackup.cfg
#@@	############################################################@@
#@@	eval $(awk -F"=" '{
#@@			      if ($1~/scpIp/) print "scpIp="$2; 
#@@			      if ($1~/scpUser/) print "scpUser="$2;
#@@			      if ($1~/scpPath/) print "scpPath="$2;
#@@			  }' ./configs/scpPatchBackup.cfg)
#@@
#@@	scp -r $lastBakFileDir $scpUser@$scpIp:$scpPath
#@@	if [ $? -eq 0 ]
#@@	then
#@@		echo "Delete [$lastBakFileDir] ..."
#@@		rm -rf $lastBakFileDir
#@@	else
#@@		echo "备份昨日备份$lastBakFileDir至远程备份服务器失败！"
#@@	fi
#@@	echo "Scp [$lastBakFileDir] End..."
#@@else
#@@	echo "上一日无备份！"
#@@	sleep 1
#@@fi

#@@清理临时文件
echo "Clear Tmp File Begin ..."
cd $workPath
rm -f $newerN1
rm -f $newerN2
rm -f $serverLock
echo "Clear Tmp File End ..."

echo "Apps Backup End ..."
echo '******************************************************************************'
exit 0