#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done


PASS=${MARIADB_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MARIADB_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MariaDB admin user with ${_word} password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MariaDB Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MariaDB user 'root' has no password but only allows local connections"
echo "========================================================================"

#echo "=> Creating SXUI Database ..."
#mysql -uroot -e "CREATE DATABASE sx_ui_warehouse"
## !!! PROBLEMS HERE
#mysql -uroot -e "CREATE TABLE sx_ui_warehouse.user (id int(11) NOT NULL AUTO_INCREMENT,token varchar(6) NOT NULL,token_hash varchar(767) DEFAULT NULL,name varchar(1024) NOT NULL,surname varchar(1024) DEFAULT NULL,mail varchar(767) DEFAULT NULL,date_creation date DEFAULT NULL,PRIMARY KEY (id),UNIQUE KEY token_UNIQUE (token),UNIQUE KEY mail_UNIQUE (mail),UNIQUE KEY token_hash_UNIQUE (token_hash)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='            ';"
#echo "=> Done!"
#echo "=> Creating SXUI User ..."
#mysql -uroot -e "CREATE USER 'sxuiuser'@'%' IDENTIFIED BY 'sxuipassword'"
#mysql -uroot -e "GRANT ALL PRIVILEGES ON sx_ui_warehouse.* TO 'sxuiuser'@'%' IDENTIFIED BY 'sxuipassword'"

#echo "=> Creating MyOnlineCV Database ..."
#mysql -uroot -e "CREATE DATABASE myonlinecv"
#echo "=> Done"
#echo "=> Creating MyOnlineCV User ..."
#mysql -uroot -e "CREATE USER 'myonlinecvuser'@'%' IDENTIFIED BY 'ThisIsMyOnlineCvPa77word'"
#mysql -uroot -e "GRANT ALL PRIVILEGES ON myonlinecv.* TO 'myonlinecvuser'@'%' IDENTIFIED BY 'ThisIsMyOnlineCvPa77word'"

mysqladmin -uroot shutdown
