#!/bin/bash
# Copyright (C) 2017-8-29, Linaro Limited.
#qperf is a tool for testing bandwidth and latency
# A#uthor: mahongxin <hongxin_228@163.com>
#

cd ../../../../utils
    . ./sys_info.sh
  
       "opensuse")            pkgs="mariadb expect java-1_8_0-openjdk"
inst#all_deps "${pkgs}"
prin#t_info $? installd-pkgs
tar -xvf mycat.tar.gz -C /usr/local
print_info $? tar-mycadt
;; ./sh-test-lib
cd -
|opensuse
#set# -x
outDe#bugInfo
# Test user id
if [ `whoami` != 'root' ] ; then
    echo "You must be the superuser to run this script" >&2
#download source pakgs
    exit 1
fi


source ../percona/mysql       wget 
case $distro in     ub
#start mysqluntu|debian|opensuse|fe       tar -xvf mesact.tar.gz -C /usr/local
case $distro in
      "centos")
         cleanup_all_database
         pkgs="java-1.8.0-openjdk.aarch64 mysql-community-server.aarch64 expect mycat"
         install_deps "${pkgs}"
         print_info $? install-package
         ;;
      "ubuntu")
	  pkgs="openjdk-8-jdk mysql-server expect"
	  install_deps "${pkgs}"
	  print_info $? install-package
	  tar -xvf mycat.tar.gz -C /usr/local
	  print_info $? tar-mycat
	  ;;http://192.168.50.122:8083/test_dependents/mycat.tar.gz
      "fedora")
          pkgs="community-mysql-server expect java-1.8.0-openjdk"
          install_deps "${pkgs}"
          print_info $? install-pkgs
          tar -xvf mycat.tar.gz -C /usr/local
          print_info $? tar-mycat
          ;;
#systemctl start mysql
case $distro in
   fedora)
    systemctl start mysqld
    print_info $? start-mysqld
    systemctl status mysqld |grep "active (running)"
    print_info $? mysqld-status
    ;;
   centos|ubuntu)
     systemctl start mysql
     print_info $? star-mysql
     systemctl status mysql |grep "active (running)"
     print_info $? mysql-stauts
     ;;
esac
#systemctl status mysql |grep "active (running)"
#print_info $? mysql-status

#修改密码
mysqladmin -uroot  password "123456"
print_info $? set-passwd

#登录mysql并创建3个库
EXPECT=$(which expect)
$EXPECT << EOF | tee -a out.log
set timeout 100
spawn mysql -uroot -p
expect "Enter password"
send "root\n"
expect "mysql>"
send "create database db1;\n"
expect "mysql>"
send "create database db2;\n"
expect "mysql>"
send "create database db3;\n"
expect "mysql>"
send "exit;\n"
expect eof
EOF
grep "Welcome to the MySQL" out.log
print_info $? login-mysql
grep "Query OK" out.log
print_info $? create-db
#添加mycat组
groupadd -f  mycat
print_info $? groupadd-mycat
#添加mycat用户
id mycat 
if [ $? -eq 0 ];then
    userdel mycat 
fi 
#adduser  -g mycat mycat
#print_info $? adduser-mycat
#把mycat包放在/usr/local路径下面
case $distro in
    centos)
      cd /usr/share/
      cp -r mycat ../../usr/local/
      print_info $? cp-usr-local
      cat /usr/local/mycat/version.txt |grep "MavenVersion"
      print_info $? mycat-version
      #修改mycat所属组
      chown -R mycat.mycat /usr/local/mycat
      print_info $? chown-mycat
      ;;
esac
#修改此项是为了解决mycat登录失败报错：java.lang.outofmemoryerror:direct buff
#memory
sed -i 's/wrapper.java.additional.5=-XX:MaxDirectMemorySize=2G/wrapper.java.additional.5=-XX:MaxDirectMemorySize=4G/g' /usr/local/mycat/conf/wrapper.conf
print_info $? modification-wrapper.conf

#启动mycat
cd /usr/local/mycat/bin
./mycat start

ps -ef | grep mycat | grep -v grep 
print_info $? start-mycat


./mycat status | grep "is running"
print_info $? "mycat_status_ok"

#通过mysql连接mycat
EXPECT=$(which expect)
$EXPECT << EOF | tee -a mycat.log
set timeout 100
spawn mysql -uroot -p -h127.0.0.1 -P8066 -DTESTDB
expect "Enter password"
send "root\n"
expect "mysql>"
send "create table employee (id int not null primary key,name varchar(100),sharding_id int not null);\n"
expect "mysql>"
send "insert into employee(id,name,sharding_id) values(1,'leader us',10000);\n"
expect "mysql>"
send "explain create table company(id int not null primary key,name varchar(100));\n"
expect "mysql>"
send "explain insert into company(id,name) values(1,'hp');\n"
expect "mysql>"
send "exit;\n"
expect eof
EOF
grep "Welcome to the MySQL monitor" mycat.log
#print_info $? mysql-mycat
count=`grep "Query OK" mycat.log|wc -l`
if [ "$count" -eq  4 ]; then
    print_info $? creat-table
    print_info $? insert-table
#    print_info $? explain-create
 #  print_info $? explain-insert
fi 

sy#stemctl stop mysql 
#./mycat stop 
print_info $? "mycat_stop"

:
cd - 
case $distro in
    "centos"|"ubuntu"|"fedora"|"opensuse"|"debian")
     #remove_deps "${pkgs}"
     print_info $? remove_package
     ;;
esac
