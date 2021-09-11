#!/bin/bash

BASE_DIR=$(cd `dirname $0`;pwd)
LOG=$BASE_DIR/logs/info.log
if [ ! -d $BASE_DIR/logs ]; then
   mkdir $BASE_DIR/logs
fi

#check current user
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ];then
   echo "ERROR: must run as root!!!!"
   exit 1
fi

#init
function init()
{
   #关掉、禁用防火墙
   systemctl stop firewalld
   systemctl disable firewalld
   
   #禁用selinux：永久禁用需重启生效，此处还需临时禁用配合
   setenforce 0 >> /dev/null 2>&1
   #sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
   sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
 
   #初始化logging.yaml日志文件路径
   sed -i "s/filename: info.log/filename: ${BASE_DIR////\/}\/logs\/info.log/g" $BASE_DIR/script/logging.yaml
   sed -i "s/filename: errors.log/filename: ${BASE_DIR////\/}\/logs\/errors.log/g" $BASE_DIR/script/logging.yaml
}

#shell exec python
function execPython()
{
   python $*
   res=$?
   if [ $res'x' != '0x' ];then
      exit 1
   fi
}

#install software
function installSoft()
{
   yum localinstall -y $BASE_DIR/ansible/rpms/ansible/PyYAML*.rpm
   execPython $BASE_DIR/script/installSoft.py $BASE_DIR ansible
   execPython $BASE_DIR/script/installSoft.py $BASE_DIR expect
   execPython $BASE_DIR/script/installSoft.py $BASE_DIR pexpect
}


echo "********************BEGIN INSTALL********************">>$LOG

init

installSoft

#execPython $BASE_DIR/script/install.py

echo "********************END INSTALL********************">>$LOG
