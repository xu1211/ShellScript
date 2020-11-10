#!/bin/bash
####################################################################################################@@
#@@echo '******************************************************************************'
#@@echo '* 功能：日志文件备份脚本                                                      '
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

#@@应用日志备份截止日期
logsBackUpDate1=`date -d '1 days ago' "+%Y%m%d"`
#@@应用日志备份起始日期
logsBackUpDate2=`date -d '2 days ago' "+%Y%m%d"`

#@@本地备份根目录
bakFileRoot=~/.cronBackup
#@@日志备份文件夹
bakFileDir=$bakFileRoot/$logsBackUpDate2

#@@应用备份配置
logsCfg=$workPath/configs/$HostName/logs.cfg
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
	mkdir -p $bakFileDir/tmp
	chmod -R 777 $bakFileDir
else
	sleep 1
fi

#@@创建指定时间的文件以用于find -newer 命令
############################################
newerF1="$logsBackUpDate2"0000
newerF2="$logsBackUpDate1"0000

newerN1=$HostName-$newerF1
newerN2=$HostName-$newerF2

touch -t $newerF1 $newerN1
touch -t $newerF2 $newerN2
############################################

scpUser=""
scpIp=""
scpPath=""

echo '******************************************************************************'
echo "App Logs Backup Start ..."
#@@读取配置文件
cat $logsCfg |while read line;
do
	#@@eg:symbolsserver=/app/qhdprod/log/symbolsserver
	#@@应用名称
	logName=`echo $line | awk -F "=" '{ print $1 }'`
	#@@应用绝对路径
	logPath=`echo $line | awk -F "=" '{ print $2 }'`
	#@@备份文件名称
	arcName=$HostName-logs-$logName-$backUpDateTime

	if [ "$logName" = "" ]
	then
		echo "请检查$logsCfg配置文件有效性！"
		continue
	fi
	if [ "$logPath" = "" ]
	then
		echo "请检查$logsCfg配置文件有效性！"
		continue
	fi
	
	#@@判断文件开头是否以#开头则跳过
	echo "$logName" | grep -q "#"
	if [ $? -eq 0 ]
	then
		echo $logName
		continue	
	fi

	echo "Backup [$logName] Start, Path Value Is [$logPath] ..."

	#@@切换目录至应用文件夹
	cd $logPath
	#@@切换成功
	if [ $? -eq 0 ]
	then
		#@@区间内日志文件变化量
		find $logPath -newer $workPath/$newerN1 ! -newer $workPath/$newerN2 -wholename '*app.*'  -type f > "$bakFileDir/tmp/$arcName.list"

		#@@查找结果为空即没有变化
		if [ ! -s $bakFileDir/tmp/$arcName.list ]
		then
			#@@删除昨日备份，以实现变化全量备份
			echo "没有需要备份的日志文件！"
		else
			#@@新建当日备份
			echo "Create [$bakFileDir/$arcName.tar.gz] ..."
			tar -T $bakFileDir/tmp/$arcName.list -zcf $bakFileDir/$arcName.tar.gz
			if [ $? -eq 0 ]
			then
				#@@删除已备份的过期日志文件
				echo "Delete Archive List Logs ..."
				find $logPath ! -newer $workPath/$newerN2 -wholename '*app.*'  -type f -exec rm -f {} \;
			else
				echo "备份应用日志文件失败!"
			fi
		fi
	fi
	echo "Backup [$logName] End ..."
	cd $workPath
done

#@@备份昨日备份至备份服务器
if [ -d $bakFileDir ]
then
	echo "Scp [$bakFileDir] Begin..."
	############################################################@@
	##@@ read the config file
	##@@ config file directory is ./configs/scpPatchBackup.cfg
	############################################################@@
	eval $(awk -F"=" '{
			      if ($1~/scpIp/) print "scpIp="$2; 
			      if ($1~/scpUser/) print "scpUser="$2;
			      if ($1~/scpPath/) print "scpPath="$2;
			  }' ./configs/scpPatchBackup.cfg)
	scp -r $bakFileDir $scpUser@$scpIp:$scpPath
	if [ $? -eq 0 ]
	then
		echo "Delete [$bakFileDir] ..."
		rm -rf $bakFileDir
	else
		echo "备份$bakFileDir至远程备份服务器失败！"
	fi
	echo "Scp [$bakFileDir] End..."
else
	echo "当日日无备份！"
	sleep 1
fi


#@@清理临时文件
echo "Clear Tmp File Begin ..."
cd $workPath
rm -f $newerN1
rm -f $newerN2
rm -f $serverLock
echo "Clear Tmp File End ..."

echo "App Logs Backup End ..."
echo '******************************************************************************'
exit 0
