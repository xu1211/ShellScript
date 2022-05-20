#!/bin/bash


oldUrl='172.0.0.1:1521:odldb'
oldUser='vbank'
oldPwd='e7ef402cb6e0f362'

## vbank = e7ef402cb6e0f362
## VBANK = 28ca6d1471cad9ce

newUrl='172.16.32.202:1521:newdb'
newUser='VBANK'
newPwd='28ca6d1471cad9ce'


appPath='/app/qhdprod/app'
app1=$appPath/SmartAIBANK/configs/cache_conf/jdbcConfig.properties
app2=$appPath/SmartGuider/configuration/database_pool/pool.xml
app3=$appPath/SmartManager/configuration/database_pool/pool.xml
app4=$appPath/XMPPServer/conf/openfire.xml

str1="s/$oldUrl/$newUrl/g"
str2="s/$oldUser/$newUser/g"
str3="s/$oldPwd/$newPwd/g"

if [ -f $app1 ]
then
  echo 修改$app1
  sed -i $str1 $app1
  sed -i $str2 $app1
#  sed -i $str3 $app1
else
  echo "$app1不存在"
fi


if [ -f $app2 ]
then
  echo 修改$app2
  sed -i $str1 $app2
  sed -i $str2 $app2
#  sed -i $str3 $app2
else
  echo "$app2不存在"
fi


if [ -f $app3 ]
then
  echo 修改$app3
  sed -i $str1 $app3
  sed -i $str2 $app3
#  sed -i $str3 $app3
else
  echo "$app3不存在"
fi


if [ -f $app4 ]
then
  echo 修改$app4
  sed -i $str1 $app4
  sed -i $str2 $app4
#  sed -i $str3 $app4
else
  echo "$app4不存在"
fi





