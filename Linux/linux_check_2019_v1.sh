﻿#!/bin/bash
echo "【Linux系统安全检查脚本】"
echo "【本脚本仅为安全审计脚本，未对服务器做任何修改。】"
echo ---------------------------------------主机安全检查-----------------------
echo "【系统版本】"
uname -a
echo --------------------------------------------------------------------------
echo "【本机的ip地址是：】"
ifconfig | grep --color "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}"
echo --------------------------------------------------------------------------
echo "【1.应对登录操作系统和数据库系统的用户进行身份标识和鉴别】"
echo "【查看文件中各用户名状态，记录密码一栏为空的用户名。】"
echo "【engxz:$1$gSm3LWDj$nhwcJzNceekFLBHVsndmj/:15629:0:99999:7:::】"
echo "【其中第一个:和第二个:之间若为空，则说明存在空口令】"
echo "cat /ect/shadow>>"
cat /etc/shadow
echo --------------------------------------------------------------------------
echo "【2.操作系统和数据库系统管理用户身份标识应具有不易被冒用的特点，口令应有复杂度要求并定期更换】"
echo "【打开/etc/login.defs查看密码最小长度和有效期】"
echo "【PASS_MAX_DAYS   99999 最大天数】"
echo "【PASS_MIN_DAYS   0 最短天数】"
echo "【PASS_MIN_LEN    5 最小长度】"
echo "【PASS_WARN_AGE   7 口令失效前多少天提示】"
echo "cat /etc/login.defs>>"
more /etc/login.defs | grep -E "PASS_MAX_DAYS"
more /etc/login.defs | grep -E "PASS_MIN_DAYS"
more /etc/login.defs | grep -E "PASS_MIN_LEN"
more /etc/login.defs | grep -E "PASS_WARN_AGE"
echo "【复杂度策略查看（对root无效）】"
echo "【找到 password requisite pam_cracklib.so，如下：】"
echo "【password  requisite pam_cracklib.so retry=5  difok=3 minlen=10 ucredit=-1 lcredit=-3 dcredit=-3 dictpath=/usr/share/cracklib/pw_dict】"
echo "【参数含义：尝试次数：5】"
echo "【最少不同字符：3】"
echo "【最小密码长度：10】"
echo "【最少大写字母：1】"
echo "【最少小写字母：3】"
echo "【最少数字：3】"
echo "【密码字典：/usr/share/cracklib/pw_dict】"
echo "more /etc/pam.d/system-auth | grep pam_cracklib.so>>"
more /etc/pam.d/system-auth | grep pam_cracklib.so
echo "more /etc/pam.d/password | grep pam_cracklib.so>>"
more /etc/pam.d/password | grep pam_cracklib.so
echo --------------------------------------------------------------------------
echo "【3.应启用登录失败处理功能，可采取结束会话、限制非法登录次数和自动退出等措施】"
echo "【SSH远程登录失败次数：】"
echo "cat /etc/pam.d/sshd | grep pam_tally.so>>"
echo "【预期结果：在auth行下方：auth required pam_tally.so deny=5 unlock_time=600 no_lock_time 在account行下方：account required pam_tally.so】"
cat /etc/pam.d/sshd | grep pam_tally.so
echo "【本地登录失败次数限制：】"
echo "【存在account required /lib/security/pam_tally.so deny=3 no magic_root reset】"
echo "cat /etc/pam.d/system-auth | grep pam_tally.so>>"
cat /etc/pam.d/system-auth | grep pam_tally.so
echo "【或者存在auth required pam_env.so】"
echo "【auth required pam_tally2.so even_deny_root deny=3 unlock_time=120失败三次后锁定120秒】"
echo "【此行，必须在第二行】"
echo "cat /etc/pam.d/system-auth | grep pam_env.so>>"
cat /etc/pam.d/system-auth | grep pam_env.s
echo "【查看SSH是否配置了允许尝试的次数】"
echo "cat /etc/ssh/sshd_config | grep MaxAuthTries>>"
cat /etc/ssh/sshd_config | grep MaxAuthTries
echo --------------------------------------------------------------------------
echo "【4.当对服务器进行远程管理时，应采取必要措施，防止鉴别信息在网络传输过程中被窃听】"
echo "【是否开启了SSH服务】"
echo "service ssh status>>"
service sshd status
echo "【是否开启了Telnet服务】"
echo "service telnet status>>"
service telnet status
echo "【是否禁用Telnet服务:disable yes】"
echo "cat /etc/xinetd.d/telnet>>"
cat /etc/xinetd.d/telnet
echo --------------------------------------------------------------------------
echo "【5.应为操作系统和数据库系统的不同用户分配不同的用户名，确保用户名具有唯一性】"
echo "【查看/etc/passwd，用户名后是密码，密码后是UID，不能存在同样的UID，UID为0的只有root。】"
cat /etc/passwd
echo --------------------------------------------------------------------------
echo "【7.应启用访问控制功能，依据安全策略控制用户对资源的访问。】"
echo "【基本原则是配置文件不能大于(644)，可执行文件不能大于(755)】"
echo "ls -l /etc/passwd>> (644)】"
ls -l /etc/passwd
echo "ls -l /etc/shadow>> (400)】"
ls -l /etc/shadow
echo "ls -l /etc/xinetd.conf>> (600)】"
ls -l /etc/xinetd.conf
echo "ls -l /etc/group>> (644)】"
ls -l /etc/group
echo "ls -l /etc/security>> (600)】"
ls -l /etc/security
echo "【查看权限过大的文件】"
echo "find / -perm 777】"
find / -perm 777
echo "【查看具有SUID属性的文件】"
echo "find / -perm -4000】"
find / -perm -4000
echo "【查看具有SGID属性的文件】"
echo "find / -perm -2000】"
find / -perm -2000
echo --------------------------------------------------------------------------
echo "【8.应根据管理用户的角色分配权限，实现管理用户的权限分离，仅授予管理用户所需的最小权限】"
echo "【主机用户不存在多余账户， 用户权限实现不存在多余权限，只有root用户uid为0。】"
awk -F":" '{if($2!~/^!|^*/){print "("$1")" " 是一个未被锁定的账户，请管理员检查是否需要锁定它或者删除它。"}}' /etc/shadow
echo "【查看passwd文件中有哪些特权用户】"
awk -F: '$3==0 {print $1}' /etc/passwd
echo "【查看系统中root用户外连情况】"
lsof -u root |egrep "ESTABLISHED|SYN_SENT|LISTENING】"
echo "【禁止非wheel组用户切换到root】"
echo "【auth required /lib/security/$ISA/pam_wheel.so use_uid 找到此行并去掉行首的#】"
echo "cat /etc/pam.d/su | grep wheel>>"
cat /etc/pam.d/su | grep wheel
echo "cat /etc/login.defs | grep SU_WHEEL_ONLY>>"
cat /etc/login.defs | grep SU_WHEEL_ONLY
echo "【查看是否禁止root直接登录】"
echo "cat /etc/ssh/sshd_config | grep PermitRootLogin>>"
cat /etc/ssh/sshd_config | grep PermitRootLogin
echo --------------------------------------------------------------------------
echo "【14.审计范围应覆盖到服务器上的每个操作系统用户和数据库用户】"
echo "【查看syslog和audit日志服务是否开启】"
echo "【预期结果：syslogd (pid 3451) 正在运行...】"
echo "【rsyslogd(pid 1699) 正在运行...】"
echo "【auditd (pid 3427) 正在运行...】"
echo "service syslog status>>"
service syslog status
echo "service rsyslog status>>"
service rsyslog status
echo "service auditd status>>"
service auditd status
echo "【查看安全审计守护进程是否正常】"
echo "ps –ef | grep auditd>>"
ps –ef | grep auditd
echo "ps –ef | grep syslogd>>"
ps –ef | grep syslogd
echo --------------------------------------------------------------------------
echo "【15.审计内容应包括重要用户行为、系统资源的异常使用和重要系统命令的使用等系统内重要的安全相关事件】"
echo "【16.审计记录应包括事件的日期、时间、类型、主体标识、客体标识和结果等】"
echo "cat /etc/audit/audit.conf>>"
cat /etc/audit/audit.conf
echo "cat /etc/rsyslog.conf>>"
cat /etc/rsyslog.conf
echo "cat /etc/syslog.conf>>"
cat /etc/syslog.conf
echo --------------------------------------------------------------------------
echo "【22.应能够检测到对重要服务器进行入侵的行为，能够记录入侵的源IP、攻击的类型、攻击的目的、 攻击的时间，并在发生严重入侵事件时提供报警】"
echo "【查看是否开启了iptable防火墙和其他防护机制并配置正确，防火墙不能使用缺省配置】"
echo "service iptables status>>"
service iptables status
echo "iptables --list>>"
iptables --list
echo --------------------------------------------------------------------------
echo "【24.操作系统应遵循最小安装的原则，仅安装需要的组件和应用程序，并通过设置升级服务器等方式保 持系统补丁及时得到更新】"
echo "【查看正在运行的服务】"
echo "service --status-all | grep -E "running|start|+">>"
echo "【查看是否存在危险的服务,如echo、shell、login、finger、r等,或者非必要的服务如talk、ntalk、pop-2、sendmail、imapd、ftp、pop3等】"
service --status-all | grep -E "running|start|+"
echo "【查看是否存在无属主文件】"
echo "find / -nouser>>"
find / -nouser
echo --------------------------------------------------------------------------
echo "【28.应通过设定终端接入方式、网络地址范围等条件限制终端登录】"
echo "【查看 /etc/hosts.deny存储所有禁止访问本机的IP】"
echo "【查看 /etc/hosts.allow存储所有允许访问本机的IP】"
echo "【第一条:是否存在前面没有#的ALL:ALL】"
echo "【第二条:是否存在允许ip或者域名等】"
echo "【例:sshd: 192.168.1.10/255.255.255.0】"
echo "cat /etc/hosts.deny>>"
cat /etc/hosts.deny
echo "cat /etc/hosts.allow>>"
cat /etc/hosts.allow
echo --------------------------------------------------------------------------
echo "【29.应根据安全策略设置登录终端的操作超时锁定】"
echo "【查看/etc/profile是否设置:TIMEOUT = 600 秒】"
echo "cat /etc/profile | grep -E "TMOUT">>"
cat /etc/profile | grep -E "TMOUT"
echo --------------------------------------------------------------------------
echo "【30.应对重要服务器进行监视，包括监视服务器的CPU、硬盘、内存、网络等资源的使用情况】"
echo "【了解系统账户的资源分配情况，查看各个分区磁盘占用情况：】"
echo "df –k>>"
df -k
echo --------------------------------------------------------------------------
echo "【31.应限制单个用户对系统资源的最大或最小使用限度】"
echo "【查看/etc/security/limits.conf 中的参数nproc可设置最大进程数】"
echo "【soft    nproc   2047 进程的最大数目】"
echo "【hard    nproc   16384】"
echo "【soft    nofile  1024 打开文件的最大数目】"
echo "【hard    nofile  65536】"
echo "【查看是否有@student – maxlogins 1类似设置，数字代表此用户可同时登录的个数】"
echo "cat /etc/security/limits.conf>>"
cat /etc/security/limits.conf
echo --------------------------------------------------------------------------